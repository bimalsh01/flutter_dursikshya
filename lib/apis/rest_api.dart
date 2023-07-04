import 'package:dio/dio.dart';

class RestAPI {
  static getUser() async {
    final dio = Dio();
    String url = 'https://reqres.in/api/users?page=2';

    var result = await dio.get(url);
    return result.data;
  }
}
