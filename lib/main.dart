import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() async {
  print(await getData());
  runApp(MaterialApp(
    home: Container(),
  ));
}

Future<Map> getData() async {
  final response = await http
      .get(Uri.parse('https://api.hgbrasil.com/finance?key=f2b7824c'));
  return json.decode(response.body);
}
