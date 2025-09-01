import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

final DatabaseReference topGenresDB = FirebaseDatabase.instance.ref(
  'TopGenres',
);
final DatabaseReference browseAllDB = FirebaseDatabase.instance.ref(
  'BrowseAll',
);

Future<List<Map<String, dynamic>>> getGenres() async {
  final snapshot = await topGenresDB.once();
  final data = snapshot.snapshot.value;
  if (data == null || (data is! List && data is! Map)) return [];
  final List<Map<String, dynamic>> genreList = [];
  if (data is List) {
    for (final item in data) {
      if (item != null && item is Map) {
        genreList.add({
          "id": item['id'],
          "image": item['image'],
          "name": item['name'],
          "color": item['color'],
        });
      }
    }
  } else if (data is Map) {
    data.forEach((key, value) {
      if (value != null && value is Map) {
        genreList.add({
          "id": value['id'],
          "image": value['image'],
          "name": value['name'],
          "color": value['color'],
        });
      }
    });
  }
  return genreList;
}

Future<List<Map<String, dynamic>>> getBrowseAll() async {
  final snapshot = await browseAllDB.once();
  final data = snapshot.snapshot.value;
  if (data == null || (data is! List && data is! Map)) return [];
  final List<Map<String, dynamic>> browseList = [];
  if (data is List) {
    for (final item in data) {
      if (item != null && item is Map) {
        browseList.add({
          "id": item['id'],
          "image": item['image'],
          "name": item['name'],
          "color": item['color'],
        });
      }
    }
  } else if (data is Map) {
    data.forEach((key, value) {
      if (value != null && value is Map) {
        browseList.add({
          "id": value['id'],
          "image": value['image'],
          "name": value['name'],
          "color": value['color'],
        });
      }
    });
  }
  return browseList;
}

final String baseurl = 'https://snowcone-45bcb-default-rtdb.firebaseio.com';

Future<List<dynamic>> getData(String node) async {
  final response = await http.get(Uri.parse('$baseurl/$node.json'));

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    if (decoded is List) {
      return decoded;
    } else {
      throw Exception('Unexpected data format: expected a list');
    }
  } else {
    throw Exception('Failed to fetch data');
  }
}
