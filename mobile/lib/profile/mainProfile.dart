import 'package:flutter/material.dart';
import 'package:mobile/Model/profileModel.dart';
import 'package:mobile/NetworkHandler.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({super.key});

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = false;
  late Future<ProfileModel> profileModel;

  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    super.initState();
    profileModel = fetchData();
  }

  Future<ProfileModel> fetchData() async {
    final res = await networkHandler.get("/profile/getData");
    return ProfileModel.fromJson(res['data']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: circular
          ? CircularProgressIndicator()
          : FutureBuilder<ProfileModel>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      head(),
                      Divider(thickness: 0.8),
                      otherDetails('name', snapshot.data!.name),
                      otherDetails('About', snapshot.data!.about),
                      otherDetails('Profession', snapshot.data!.profession),
                      otherDetails('DOB', snapshot.data!.DOB),
                      Divider(
                        thickness: 0.8,
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
    );
  }

  Widget head() {
    return Center(
      child: circular
          ? CircularProgressIndicator()
          : FutureBuilder<ProfileModel>(
              future: fetchData(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundImage: NetworkHandler().getImage(
                              snapshot.data!.username,
                            ),
                            radius: 50,
                          ),
                        ),
                        Text(
                          snapshot.data!.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          snapshot.data!.titleline,
                        )
                      ],
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
            ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
