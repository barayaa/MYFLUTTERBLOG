import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/NetworkHandler.dart';
import 'package:mobile/pages/homePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isVisible = true;

  NetworkHandler networkHandler = NetworkHandler();
  final _globalKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color.fromARGB(255, 166, 219, 243),
              ],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated,
            ),
          ),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign up With Email',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                userNameTextField(),
                emailTextField(),
                passwordTextField(),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    await checkUser();
                    if (_globalKey.currentState!.validate() && validate) {
                      Map<String, String> data = {
                        "username": _usernameController.text,
                        "email": _emailController.text,
                        "password": _passwordController.text
                      };
                      print(data);

                      var responseRegister =
                          await networkHandler.post('/user/register', data);
                      if (responseRegister.statusCode == 200 ||
                          responseRegister.statusCode == 201) {
                        Map<String, String> data = {
                          "username": _usernameController.text,
                          "password": _passwordController.text,
                        };
                        var response =
                            await networkHandler.post("/user/login", data);

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          Map<String, dynamic> output =
                              json.decode(response.body);
                          print(output["token"]);
                          await storage.write(
                              key: "token", value: output["token"]);

                          setState(() {
                            validate = true;
                            circular = false;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (route) => false);
                        } else {
                          // Scaffold.of(context).showSnackBar(
                          //     SnackBar(content: Text("Netwok Error")));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Netwok Error"),
                              duration: Duration(milliseconds: 300),
                            ),
                          );
                        }
                      }

                      setState(() {
                        circular = false;
                      });
                    } else {
                      setState(() {
                        circular = false;
                      });
                    }
                  },
                  child: circular
                      ? CircularProgressIndicator()
                      : Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(
                              0xff00A86B,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'LOGIN',
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        //circular = false;
        validate = false;
        errorText = "Username can't be Empty";
      });
    } else {
      var response = await networkHandler
          .get('/user/checkUsername/${_usernameController.text}');
      if (response['Status'] == true) {
        setState(() {
          //  circular = false;
          validate = false;
          errorText = "Username already exist";
        });
      } else {
        setState(() {
          validate = true;
        });
      }
    }
  }

  Widget userNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text('username'),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              errorText: validate ? null : errorText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text('Email'),
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (!value!.contains('@')) {
                return "Email can't be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text('Password'),
          TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value!.isEmpty && value.length < 5) {
                return "wrong Password";
              }
              return null;
            },
            obscureText: isVisible,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              helperText: "Password length should be have < 5",
              helperStyle: TextStyle(
                fontSize: 15,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
