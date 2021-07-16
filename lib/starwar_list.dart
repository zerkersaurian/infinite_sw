import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'starwar_repo.dart';

class StarwarList extends StatefulWidget {
  @override
  _StarwarListState createState() => _StarwarListState();
}

class _StarwarListState extends State<StarwarList> {
  List<String> sw_image = [];
  List<People> sw_people = [];
  int i = 1;
  @override
  void initState() {
    super.initState();
    fetchPeople(1);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sw_people.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 700,
          child: Column(children: [
            Text('name : ${sw_people[index].name}'),
            Image.network(sw_image[index]),
          ]),
        );
      },
    );
  }

  fetchPeople(page) async {
    int x = 0;
    var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
    List<dynamic> results = response.data['results'];

    var res = results.map((it) => People.fromJson(it)).toList();

    setState(() {
      sw_people = sw_people + res;
      for (x = i; x <= res.length + 1; x++) {
        sw_image.add(
            'https://starwars-visualguide.com/assets/img/characters/$x.jpg');
      }
      i += x;
    });
  }
}
