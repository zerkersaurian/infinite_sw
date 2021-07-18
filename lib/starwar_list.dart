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
  ScrollController _scrollController = new ScrollController();     // Use ScrollController to get scroll position in app

  @override
  void initState() {
    super.initState();
    fetchPeople(page);
    _scrollController.addListener(() {                             // if scroll position reach at the end of max height then fetch data again
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
      itemCount: sw_people.length,                                // total item is equal to our Starwar People list
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.lightBlue[color[index]],                  // color list that will add together when fetch data
          height: 200,
          child: Row(children: [                                  // Row
            Image.network(sw_image[index]),
            Padding(padding: EdgeInsets.only(left: 20)),
            Column(                                               // Column
              mainAxisAlignment: MainAxisAlignment.center,        // horizontal alignment
              crossAxisAlignment: CrossAxisAlignment.start,       // vertical alignment
              children: [
                Text('Name    :  ${sw_people[index].name}',
                    style: TextStyle(
                        color: Colors.grey[900],
                        decoration: TextDecoration.none,
                        fontSize: 35)),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text('Gender  :  ${sw_people[index].gender}',
                    style: TextStyle(
                        color: Colors.grey[800],
                        decoration: TextDecoration.none,
                        fontSize: 35)),
              ],
            )
          ]),
        );
      },
    );
  }

  fetchPeople(page) async {
    var res = await getjson(page);                                                          // call function from starwar_repo.dart
    setState(() {
      sw_people = sw_people + res;                                                          // add fetched data to our People List
      for (int i = 0; i < res.length; i++) {                                                // loop to add image url and color lighting within fetched data's length
        sw_image.add(
            'https://starwars-visualguide.com/assets/img/characters/${res[i].id}.jpg');
        if (((i + 1) * 100) % 1000 == 0)
          color.add(50);                                                                    // if it's 0 color will be white
        else
          color.add(((i + 1) * 100) % 1000);
      }
      print(sw_people.length);                                                              // to check List length
    });
  }
}
