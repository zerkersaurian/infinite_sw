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
  List<int> color = [];
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
          color: Colors.lightBlue[color[index]],
          height: 750,
          child: Column(children: [
            Padding(padding: EdgeInsets.only(top: 35)),
            Text('Name : ${sw_people[index].name}',
                style: TextStyle(
                    color: Colors.grey[900],
                    decoration: TextDecoration.none,
                    fontSize: 45)),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text('Gender : ${sw_people[index].gender}',
                style: TextStyle(
                    color: Colors.grey[800],
                    decoration: TextDecoration.none,
                    fontSize: 35)),
            Padding(padding: EdgeInsets.only(bottom: 15)),
            Image.network(sw_image[index]),
          ]),
        );
      },
    );
  }

  fetchPeople(page) async {
    var res = await getjson(page);
    setState(() {
      sw_people = sw_people + res;
      for (int i = 0; i < res.length; i++) {
        sw_image.add(
            'https://starwars-visualguide.com/assets/img/characters/${res[i].id}.jpg');
        if (((i + 1) * 100) % 1000 == 0)
          color.add(50);
        else
          color.add(((i + 1) * 100) % 1000);
      }
      print(sw_people.length);
    });
  }
}
