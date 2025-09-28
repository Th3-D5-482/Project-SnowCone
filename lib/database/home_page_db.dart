import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

final String baseUrl = 'https://snowcone-45bcb-default-rtdb.firebaseio.com/';

Stream<List<dynamic>> getMusic(String encode) async* {
  while (true) {
    try {
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
    } on SocketException catch (e) {
      ('SocketException: ${e.message}');
      // Optionally yield an empty list or retry logic
    } on TimeoutException catch (e) {
      ('TimeoutException: ${e.message}');
      // Handle timeout gracefully
    } on HandshakeException catch (e) {
      ('HankshakeException: ${e.message}');
    }
    await Future.delayed(Duration(seconds: 5));
  }
}

Stream<List<dynamic>> getTopMixes(String encode) async* {
  while (true) {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$encode.json'));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          yield decoded;
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } on SocketException catch (e) {
      ('SocketException: ${e.message}');
      // Optionally yield an empty list or retry logic
    } on TimeoutException catch (e) {
      ('TimeoutException: ${e.message}');
      // Handle timeout gracefully
    } on HandshakeException catch (e) {
      ('HankshakeException: ${e.message}');
    }
    await Future.delayed(Duration(seconds: 5));
  }
}

Stream<List<dynamic>> getConitnueListening(String encode) async* {
  while (true) {
    try {
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
    } on SocketException catch (e) {
      ('SocketException: ${e.message}');
      // Optionally yield an empty list or retry logic
    } on TimeoutException catch (e) {
      ('TimeoutException: ${e.message}');
      // Handle timeout gracefully
    } on HandshakeException catch (e) {
      ('HankshakeException: ${e.message}');
    }
    await Future.delayed(Duration(seconds: 5));
  }
}

Stream<List<dynamic>> getArtist(String encode) async* {
  while (true) {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/$encode.json'))
          .timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          yield decoded;
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      ('SocketException: ${e.message}');
      // Optionally yield an empty list or retry logic
    } on TimeoutException catch (e) {
      ('TimeoutException: ${e.message}');
      // Handle timeout gracefully
    } on HandshakeException catch (e) {
      ('HankshakeException: ${e.message}');
    }
    await Future.delayed(Duration(seconds: 5));
  }
}
