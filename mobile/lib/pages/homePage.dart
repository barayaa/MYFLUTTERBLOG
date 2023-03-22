import 'package:flutter/material.dart';
import 'package:mobile/blog/addBlog.dart';
import 'package:mobile/pages/wellcome_page.dart';
import 'package:mobile/screen/homeScreen.dart';
import 'package:mobile/profile/profileScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/NetworkHandler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = new FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();

  int currentState = 0;
  List<Widget> widgets = [Home_Screen(), ProfileScreen()];
  List<String> titleStrings = ["Home Page", "Profile Page"];
  String? username;

  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(
        50,
      ),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    setState(() {
      username = response['username'];
    });
    if (response["status"] == true) {
      setState(() {
        profilePhoto = CircleAvatar(
          backgroundImage: NetworkHandler().getImage(response['username']),
          radius: 50,
        );
      });
    } else {
      setState(
        () {
          profilePhoto = Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                50,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleStrings[currentState]),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  profilePhoto,
                  SizedBox(
                    height: 15,
                  ),
                  Text('@${username}')
                ],
              ),
            ),
            ListTile(
              title: Text(
                'All Post',
              ),
              trailing: Icon(
                Icons.launch,
              ),
            ),
            ListTile(
              title: Text('New History'),
              trailing: Icon(Icons.add),
            ),
            ListTile(
              title: Text('Settings'),
              trailing: Icon(Icons.settings),
            ),
            ListTile(
              title: Text('Feedback'),
              trailing: Icon(Icons.feedback),
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(
                Icons.power_settings_new,
              ),
              onTap: logOut,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                color: currentState == 0 ? Colors.white : Colors.white54,
                onPressed: () {
                  setState(() {
                    currentState = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                ),
              ),
              IconButton(
                color: currentState == 1 ? Colors.white : Colors.white54,
                onPressed: () {
                  setState(() {
                    currentState = 1;
                  });
                },
                icon: Icon(
                  Icons.person,
                ),
              )
            ],
          ),
        ),
      ),
      body: widgets[currentState],
    );
  }

  void logOut() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WellcomePage(),
        ),
        (route) => false);
  }
}
