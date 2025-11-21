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
    if (decoded is Map<String, dynamic>) {
      return decoded.values
          .whereType<Map>()
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return [];
  } else {
    throw Exception('Failed to load favorites: ${response.statusCode}');
  }
}

Stream<List<Map<String, dynamic>>> getFavoritesData(String encode) async* {
  while (true) {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$encode.json'));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded == null) {
          yield [];
        } else if (decoded is Map<String, dynamic>) {
          yield decoded.values
              .whereType<Map<String, dynamic>>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        } else if (decoded is List) {
          yield decoded
              .whereType<Map<String, dynamic>>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        } else {
          yield [];
        }
      } else {
        // You can either throw or yieldError here
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }
    } catch (e) {
      // Optional: yieldError instead of throwing
      yield [];
    }

    // Respect cancellation: if the stream is closed, break out
    if (!await Future.delayed(const Duration(seconds: 5), () => true)) {
      break;
    }
  }
}

Future<void> writeFavorite(
  int id,
  String email,
  bool isFavorite,
  String background,
  String image,
  String name,
  String audio,
  String lyrics,
  String chords,
) async {
  final safeEmail = email.replaceAll('.', '_').replaceAll('@', '_');
  Uri.parse('$baseUrl/Favorites/$safeEmail/$id.json');
  final response = await http.put(
    Uri.parse('$baseUrl/Favorites/$safeEmail/$id.json'),
    body: json.encode({
      'id': id,
      'isFavorite': isFavorite,
      'backgroundColor': background,
      'image': image,
      'name': name,
      'audio': audio,
      'lyrics': lyrics,
      'chords': chords,
    }),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to write to Favorites');
  }
}

Future<void> deleteFavorites(int songId, String email) async {
  final safeEmail = email.replaceAll('.', '_').replaceAll('@', '_');
  final response = await http.delete(
    Uri.parse('$baseUrl/Favorites/$safeEmail/$songId.json'),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to delete Favorite');
  }
}
