import 'package:firebase_database/firebase_database.dart';

final DatabaseReference topGenres = FirebaseDatabase.instance.ref('Genres');

Future<List<Map<String, dynamic>>> getGenres() async {
  final snapshot = await topGenres.once();
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
        });
      }
    });
  }
  return genreList;
}
