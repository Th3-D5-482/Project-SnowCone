import 'package:firebase_database/firebase_database.dart';

final DatabaseReference musicDB = FirebaseDatabase.instance.ref('Albums');
final DatabaseReference topMixesDB = FirebaseDatabase.instance.ref('TopMixes');
final DatabaseReference recentListeningDB = FirebaseDatabase.instance.ref(
  'Music',
);

Stream<List<Map<String, dynamic>>> getContinueListening() {
  return musicDB.onValue.map((event) {
    final data = event.snapshot.value;
    if (data == null || data is! List) return [];
    final List rawList = data;
    return rawList.where((item) => item != null).map((item) {
      final song = item as Map<dynamic, dynamic>;
      return {
        "id": song['id'],
        "name": song['name'],
        "image": song['image'],
        "isContinueListening": song['isContinueListening'],
      };
    }).toList();
  });
}

Future<List<Map<String, dynamic>>> getTopMixes() async {
  final snapshot = await topMixesDB.once();
  final data = snapshot.snapshot.value;

  if (data == null || (data is! List && data is! Map)) return [];

  final List<Map<String, dynamic>> mixesList = [];

  if (data is List) {
    for (final item in data) {
      if (item != null && item is Map) {
        mixesList.add({
          "id": item['id'],
          "name": item['name'],
          "image": item['image'],
        });
      }
    }
  } else if (data is Map) {
    data.forEach((key, value) {
      if (value != null && value is Map) {
        mixesList.add({
          "id": value['id'],
          "name": value['name'],
          "image": value['image'],
        });
      }
    });
  }

  return mixesList;
}

Stream<List<Map<String, dynamic>>> getMusic() {
  return recentListeningDB.onValue.map((event) {
    final data = event.snapshot.value;
    if (data == null || data is! List) return [];
    final List rawData = data;
    return rawData.where((item) => item != null).map((item) {
      final songs = item as Map<dynamic, dynamic>;
      return {
        "id": songs['id'],
        "name": songs['name'],
        "artist": songs['artist'],
        "releaseYear": songs['releaseYear'],
        "duration": songs['duration'],
        "image": songs['image'],
        "audio": songs['audio'],
        "genre": songs['genre'],
        "key": songs['key'],
        "bpm": songs['bpm'],
        "keyTheme": songs['keyTheme'],
        "description": songs['description'],
        "isRecentlyListened": songs['isRecentlyListened'],
      };
    }).toList();
  });
}
