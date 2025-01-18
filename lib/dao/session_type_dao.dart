import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/store/session_type.dart';

class SessionTypeDao {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _sessionTypesCollection = 'sessionTypes';

  Future<List<SessionType>> getSessionTypes() async {
    final querySnapshot = await _db.collection(_sessionTypesCollection)
        .get();

    return querySnapshot.docs
        .map((doc) => SessionType.fromDocument(doc))
        .toList();
  }

  Future<void> saveSessionType(String title, String location,
      int duration, String trainerEmail) async {
    await _db.collection(_sessionTypesCollection).add({
      'title': title,
      'location': location,
      'duration': duration,
      'trainerEmail': trainerEmail,
    });
  }
}