import 'package:firebase_database/firebase_database.dart';

final _dbRef = FirebaseDatabase.instance.ref().child('Music');

// Safely read array from Firebase
Stream<List<Map<String, dynamic>>> getMusicStream() {
  return _dbRef.onValue.map((event) {
    final data = event.snapshot.value;

    if (data == null || data is! List) return [];

    final List listData = data;

    // Filter out nulls in case Firebase array has gaps
    return listData.where((item) => item != null).map((item) {
      final song = item as Map<dynamic, dynamic>;

      return {
        'name': song['name'] ?? 'No Title',
        'image': song['image'] ?? '',
        'isContinueListening': song['isContinueListening'] ?? false,
      };
    }).toList();
  });
}
