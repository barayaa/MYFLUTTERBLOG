import 'package:flutter/material.dart';
import 'package:mobile/Model/superModel.dart';
import 'package:mobile/NetworkHandler.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key, required this.url});
  final String url;

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  late Future<SuperModel> superModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<SuperModel> fetchData() async {
    var response = await networkHandler.get(widget.url);
    return SuperModel.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: ((context, index) {
      return ListView();
    }));
  }
}
