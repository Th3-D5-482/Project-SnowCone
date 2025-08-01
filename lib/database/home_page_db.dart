import 'package:firebase_database/firebase_database.dart';

final DatabaseReference musicDB = FirebaseDatabase.instance.ref('Music');

Stream<List<Map<String, dynamic>>> getMusic() {
  return musicDB.onValue.map((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>?;
    if (data == null) return [];
    return data.entries.map((entry) {
      final item = entry.value as Map<dynamic, dynamic>;
      return {
        'id': item['id'],
        'name': item['name'],
        'artist': item['artist'],
        'releaseYear': item['releaseYear'],
        'album': item['album'],
        'duration': item['duration'],
        'image': item['image'],
        'audio': item['audio'],
        'genre': item['genre'],
        'key': item['key'],
        'bpm': item['bpm'],
        'keyTheme': item['keyTheme'],
        'description': item['description'],
        'isContinueListening': item['isContinueListening'] ?? false,
      };
    }).toList();
  });
}
