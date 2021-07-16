import 'package:dio/dio.dart';

class People {
  final String name;
  final String url;
  final String height;
  final String id;
  People(this.name, this.url, this.height, this.id);

  factory People.fromJson(dynamic data) {
    return People(data['name'], data['url'], data['height'],
        data['url'].split('https://swapi.dev/api/people/')[1].split('/')[0]);
  }
  get getName => name;
}

Future<List<People>> getjson({int page = 1}) async {
  var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
  List<dynamic> results = response.data['results'];
  return results.map((it) => People.fromJson(it)).toList();
}
