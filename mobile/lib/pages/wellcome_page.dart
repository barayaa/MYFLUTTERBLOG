import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:mobile/pages/signInPage.dart';
import 'package:mobile/pages/signUpPage.dart';
import 'package:http/http.dart' as http;

class WellcomePage extends StatefulWidget {
  const WellcomePage({super.key});

  @override
  State<WellcomePage> createState() => _WellcomePageState();
}

class _WellcomePageState extends State<WellcomePage>
    with TickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<Offset> animation1;
  final facebookLogin = FacebookLogin();

  Map? data;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();

    // _controller = AnimationController(
    //     duration: Duration(microseconds: 2500), vsync: this);
    // animation1 = Tween<Offset>(
    //   begin: Offset(0.0, 6.0),
    //   end: Offset(0.0, 0.0),
    // ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    // _controller.forward();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   // _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.lightBlue,
            ],
            begin: FractionalOffset(0.0, 1.0),
            end: FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 40,
          ),
          child: Column(
            children: [
              Text(
                'FullStack',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),
              Text(
                'Great stories for great peaople',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              boxContainer("assets/google.png", "Sign up with Google", null),
              SizedBox(
                height: 20,
              ),
              boxContainer(
                  "assets/facebook1.png", "Sign up with Facebook", onFbLogin),
              SizedBox(
                height: 20,
              ),
              boxContainer(
                  "assets/email2.png", "Sign up with Email", onEmailClick),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account ?',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Text(
                      'SignIn',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future onFbLogin() async {
    // final result = await FacebookLogin.login()
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken;
        final response = await http.get(Uri.parse(
            "https://graph.facebook.com/v4.0/me?fields=name,picture,email&access_token=${token}"));
        final data1 = json.decode(response.body);

        print(data);
        setState(() {
          isLogin = true;
          data = data1;
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          isLogin = false;
        });
        break;
      case FacebookLoginStatus.error:
        setState(() {
          isLogin = false;
        });
        break;
    }
  }

  onEmailClick() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  // onEmailAndPassword() {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => SignIn()));
  // }

  Widget boxContainer(String path, String text, onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 140,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Image.asset(
                path,
                height: 40,
                width: 30,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
