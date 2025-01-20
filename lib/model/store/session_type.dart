import 'package:cloud_firestore/cloud_firestore.dart';

class SessionType {
  final String title;
  final String location;
  final Duration duration;
  final String trainerEmail;
  final String trainerName;

  SessionType(this.title, this.location, this.duration,
      this.trainerEmail, this.trainerName);

  SessionType.fromDocument(DocumentSnapshot doc)
      : title = doc['title'] as String,
        location = doc['location'] as String,
        duration = Duration(minutes: doc['duration'] as int),
        trainerEmail = doc['trainerEmail'] as String,
        trainerName = doc['trainerName'] as String;

  SessionType.fromMap(Map<String, dynamic> map)
      : title = map['title'] as String,
        location = map['location'] as String,
        duration = Duration(minutes: map['duration'] as int),
        trainerEmail = map['trainerEmail'] as String,
        trainerName = map['trainerName'] as String;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'duration': duration.inMinutes,
      'trainerEmail': trainerEmail,
      'trainerName': trainerName,
    };
  }
}