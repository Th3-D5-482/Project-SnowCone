import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final String baseUrl = 'https://snowcone-45bcb-default-rtdb.firebaseio.com/';

Future<List<dynamic>> getMusic(String encode) async {
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

Future<List<dynamic>> getTopMixes(String encode) async {
  final response = await http.get(Uri.parse('$baseUrl/$encode.json'));
  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    if (decoded is List) {
      return decoded;
    } else {
      throw Exception('Failed to load data');
    }
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> getConitnueListening(String encode) async {
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

Future<List<dynamic>> getArtist(String encode) async {
  final response = await http
      .get(Uri.parse('$baseUrl/$encode.json'))
      .timeout(Duration(seconds: 5));
  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    if (decoded is List) {
      return decoded;
    } else {
      throw Exception('Unexpected data format');
    }
  } else {
    throw Exception('HTTP error: ${response.statusCode}');
  }
}

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

Future<List<Map<String, dynamic>>> getFavorites(String encode) async {
  final response = await http.get(Uri.parse('$baseUrl/$encode.json'));
  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    if (decoded == null) return [];
    if (decoded is Map) {
      return decoded.values
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  } else {
    throw Exception('Failed to load');
  }
}

Future<void> writeFavorite(int songId, bool isFavorite) async {
  final response = await http.put(
    Uri.parse('$baseUrl/Favorites/$songId.json'),
    body: json.encode({'songId': songId, 'isFavorite': isFavorite}),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to write to Favorites');
  }
}

Future<void> deleteFavorites(int songId) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/Favorites/$songId.json'),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to delete Favorite');
  }
}
