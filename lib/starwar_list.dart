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
  int page = 1;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    fetchPeople(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          page += 1;
          if (page > 9) {
            page %= 9;
          }
          fetchPeople(page);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
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
    var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
    List<dynamic> results = response.data['results'];
    var res = results.map((it) => People.fromJson(it)).toList();
    setState(() {
      sw_people = sw_people + res;
      for (int i = 0; i < res.length; i++) {
        sw_image.add(
            'https://starwars-visualguide.com/assets/img/characters/${res[i].id}.jpg');
      }
      print(sw_people.length);
    });
  }
}
