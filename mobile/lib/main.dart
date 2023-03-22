import 'package:flutter/material.dart';
import 'package:mobile/blog/addBlog.dart';
import 'package:mobile/pages/homePage.dart';
import 'package:mobile/pages/loadingPage.dart';
import 'package:mobile/pages/signInPage.dart';
import 'package:mobile/pages/wellcome_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/profile/mainProfile.dart';
import 'package:mobile/profile/profileScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = new FlutterSecureStorage();
  Widget page = WellcomePage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await storage.read(key: "token");

    if (token != null) {
      setState(() {
        page = HomePage();
      });
    } else {
      page = WellcomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: page,
    );
  }
}
