import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String URL_API = "shift.naliv.kz";

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  if (token.isNotEmpty) {
    return token;
  } else {
    return '';
  }
}

Future<bool?> login(String login) async {
  var url = Uri.https(URL_API, 'api/user/login.php');
  http.Response response;
  try {
    response = await http.post(
      url,
      body: json.encode({'login': login}),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    print(e);
    return null;
  }
  var data = jsonDecode(response.body);
  print("LOGIN QUERY ENDED WITH RESULT ${response.statusCode}");
  if (data == null) {
    return false;
  }
  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", data["name"]);
    prefs.setString("user_id", data["user_id"]);
    prefs.setString("token", data["token"]);
    return true;
  } else {
    return false;
  }
}

Future<List> getShifts(int month) async {
  String? token = await getToken();
  if (token.isNotEmpty) {
    return [];
  }
  var url = Uri.https(URL_API, 'api/user/getShifts.php');
  var response = await http.post(url,
      headers: {"Content-Type": "application/json", "AUTH": token},
      body: json.encode({'month': month}));

  // List<dynamic> list = json.decode(response.body);
  List data = json.decode(utf8.decode(response.bodyBytes));
  print(data);
  return data;
}
