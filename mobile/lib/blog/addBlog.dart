import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/CustomWidget/overlayCard.dart';
import 'package:mobile/Model/addblogModel.dart';
import 'package:mobile/NetworkHandler.dart';
import 'package:mobile/pages/homePage.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();

  late Future<AddblogModel> addblogModel;

  // addblog(String _title, String _body) async {
  //   if (_imageFile != null && _globalKey.currentState!.validate()) {
  //     var response = await networkHandler
  //         .post("/blogpost/Add", {"title": _title, "body": _body});
  //     return response.body;
  //   }
  // }

  final ImagePicker _picker = ImagePicker();
  // ignore: unused_field
  XFile? _imageFile;
  IconData iconPhoto = Icons.image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_imageFile != null && _globalKey.currentState!.validate()) {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => OverlayCard(
                    imagefile: _imageFile!,
                    title: _title.text,
                  ),
                );
              }
            },
            child: Text(
              'Preview',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            titleTextField(),
            SizedBox(
              height: 10,
            ),
            bodyTextFeld(),
            SizedBox(
              height: 10,
            ),
            addButton()
          ],
        ),
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value!.isEmpty) {
            return "Title can't be empty";
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
            ),
          ),
          labelText: 'Add Image and Title',
          prefixIcon: IconButton(
            onPressed: takeCoverPhoto,
            icon: Icon(
              iconPhoto,
              color: Colors.teal,
            ),
          ),
        ),
        //maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextFeld() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value!.isEmpty) {
            return "this field can't be empty";
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
          labelText: 'Blog details',
        ),
        maxLines: 5,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () async {
        // addblog(_title.text, _body.text);
        if (_imageFile != null && _globalKey.currentState!.validate()) {
          var response = await networkHandler.post(
              "/blogpost/Add", {"title": _title.text, "body": _body.text});
          print(response.body);

          if (response.statusCode == 200 || response.statusCode == 201) {
            String id = json.decode(response.body)["data"];
            var imageResponse = await networkHandler.patchImage(
                "/blogpost/add/coverImage/${id}", _imageFile!.path);
            print(imageResponse.statusCode);
            if (imageResponse.statusCode == 200 &&
                imageResponse.statusCode != 201) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (route) => false,
              );
            }
          }
        }
      },
      child: Center(
        child: Container(
          height: 60,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Center(
              child: Text(
            'Add Blog',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }

  void takeCoverPhoto() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile!;
      iconPhoto = Icons.check_box;
    });
  }

  // Future<File?> takeCoverPhoto() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     _imageFile = image!;
  //     iconPhoto = Icons.check_box;
  //   });

  //   final File? file = File(image!.path);
  //   return file;
  // }
}
