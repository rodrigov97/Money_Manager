import 'dart:convert';
import 'package:http/http.dart' as http;

var key = 'bcb47b9d';
String request = "https://api.hgbrasil.com/finance?format=json&key=$key";

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}