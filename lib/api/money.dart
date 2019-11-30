import 'dart:convert';
import 'package:http/http.dart' as http;

const request = "https://api.hgbrasil.com/finance?format=json&key=44d0329f";

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}