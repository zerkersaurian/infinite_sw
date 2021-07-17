import 'package:dio/dio.dart';

class People {
  final String name;
  final String gender;
  final String id;
  People(this.name, this.gender, this.id);

  factory People.fromJson(dynamic data) {
    return People(data['name'], data['gender'],
        data['url'].split('https://swapi.dev/api/people/')[1].split('/')[0]);
  }
}

Future<List<People>> getjson(int page) async {
  var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
  List<dynamic> results = response.data['results'];
  return results.map((it) => People.fromJson(it)).toList();
}
