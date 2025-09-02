import 'dart:convert';

import 'package:http/http.dart' as http;

final String baseUrl = 'https://snowcone-45bcb-default-rtdb.firebaseio.com/';
Future<List<dynamic>> getTopGeneres(String encode) async {
  final respose = await http.get(Uri.parse('$baseUrl/$encode.json'));
  if (respose.statusCode == 200) {
    final decoded = json.decode(respose.body);
    if (decoded is List) {
      return decoded;
    } else {
      throw Exception('Failed to load data');
    }
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> getBrowseAll(String encode) async {
  final respose = await http.get(Uri.parse('$baseUrl/$encode.json'));
  if (respose.statusCode == 200) {
    final decoded = json.decode(respose.body);
    if (decoded is List) {
      return decoded;
    } else {
      throw Exception('Failed to load data');
    }
  } else {
    throw Exception('Failed to load data');
  }
}
