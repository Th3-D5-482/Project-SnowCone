import 'dart:convert';

import 'package:http/http.dart' as http;

final String baseUrl = 'https://snowcone-45bcb-default-rtdb.firebaseio.com/';

Stream<List<dynamic>> getMusic(String encode) async* {
  while (true) {
    final respose = await http.get(Uri.parse('$baseUrl/$encode.json'));
    if (respose.statusCode == 200) {
      final decoded = json.decode(respose.body);
      if (decoded is List) {
        yield decoded;
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
    await Future.delayed(Duration(seconds: 1));
  }
}

Future<List<dynamic>> getTopMixes(String encode) async {
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

Stream<List<dynamic>> getConitnueListening(String encode) async* {
  while (true) {
    final respose = await http.get(Uri.parse('$baseUrl/$encode.json'));
    if (respose.statusCode == 200) {
      final decoded = json.decode(respose.body);
      if (decoded is List) {
        yield decoded;
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
    await Future.delayed(Duration(seconds: 1));
  }
}
