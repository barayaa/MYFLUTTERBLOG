import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/NetworkHandler.dart';
import 'package:mobile/pages/homePage.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  XFile? _imageFile;
  final networkHandler = NetworkHandler();
  final ImagePicker _picker = ImagePicker();
  final _globalKey = GlobalKey<FormState>();
  bool circular = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _about = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              profileImage(),
              SizedBox(
                height: 12,
              ),
              nameTextFormField(),
              SizedBox(
                height: 12,
              ),
              professionTextFormField(),
              SizedBox(
                height: 12,
              ),
              dobField(),
              SizedBox(
                height: 12,
              ),
              titleTextFormField(),
              SizedBox(
                height: 12,
              ),
              aboutTextFormField(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  if (_globalKey.currentState!.validate()) {
                    Map<String, String> data = {
                      "name": _name.text,
                      "profession": _profession.text,
                      "DOB": _dob.text,
                      "titleline": _title.text,
                      "about": _about.text
                    };
                    var response = await networkHandler.post(
                      "/profile/add",
                      data,
                    );
                    print(response.statusCode);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      if (_imageFile?.path != null) {
                        var imageResponse = await networkHandler.patchImage(
                          "/profile/add/image",
                          _imageFile!.path,
                        );
                        if (imageResponse.statusCode == 200) {
                          setState(() {
                            circular = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (route) => false);
                        }
                      } else {
                        setState(
                          () {
                            circular = false;
                          },
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.teal,
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget nameTextFormField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) {
          return "name can't be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "Abdoul Wahab",
      ),
    );
  }

  Widget professionTextFormField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value!.isEmpty) {
          return "profession can't be empty";
        }
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.desk,
            color: Colors.green,
          ),
          labelText: "Profession",
          helperText: "profession can't be empty",
          hintText: "Abdoul Wahab"),
    );
  }

  Widget profileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 54,
            backgroundImage: _imageFile == null
                ? AssetImage("assets/profile.jpeg")
                : FileImage(File(_imageFile!.path)) as ImageProvider,
          ),
          Positioned(
            bottom: 10,
            right: 17,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                label: Text(
                  'Camera',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(
                    ImageSource.gallery,
                  );
                },
                icon: Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                label: Text(
                  'Gallery',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    XFile? pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget dobField() {
    return TextFormField(
      controller: _dob,
      validator: (value) {
        if (value!.isEmpty) {
          return "DOB can't be empty";
        }
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.calendar_month,
            color: Colors.green,
          ),
          labelText: "Date of Bith",
          helperText: "dd/mm/yyyy",
          hintText: "Abdoul Wahab"),
    );
  }

  Widget titleTextFormField() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value!.isEmpty) {
          return "title can't be empty";
        }
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.green,
          ),
          labelText: "Title",
          helperText: "Name can't be empty",
          hintText: "Abdoul Wahab"),
    );
  }

  Widget aboutTextFormField() {
    return TextFormField(
      controller: _about,
      validator: (value) {
        if (value!.isEmpty) {
          return "profession can't be empty";
        }
        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.edit,
          color: Colors.green,
        ),
        labelText: "About",
        helperText: "Write about your self",
        hintText: "Abdoul Wahab",
      ),
    );
  }
}
