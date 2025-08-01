import 'package:firebase_database/firebase_database.dart';

final DatabaseReference musicDB = FirebaseDatabase.instance.ref('Music');

Stream<List<Map<String, dynamic>>> getMusic() {
  return musicDB.onValue.map((event) {
    final data = event.snapshot.value;

    if (data == null || data is! List) return [];

    final List rawList = data;
    // Remove any nulls (due to deleted items or gaps in Firebase array)
    return rawList.where((item) => item != null).map((item) {
      final song = item as Map<dynamic, dynamic>;
      return {
        'id': song['id'],
        'name': song['name'],
        'artist': song['artist'],
        'releaseYear': song['releaseYear'],
        'album': song['album'],
        'duration': song['duration'],
        'image': song['image'],
        'audio': song['audio'],
        'genre': song['genre'],
        'key': song['key'],
        'bpm': song['bpm'],
        'keyTheme': song['keyTheme'],
        'description': song['description'],
        'isContinueListening': song['isContinueListening'] ?? false,
      };
    }).toList();
  });
}
