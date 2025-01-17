import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final DateTime date;
  final String timeInterval;
  final String userEmail;

  Appointment(this.date, this.timeInterval, this.userEmail);

  Appointment.fromDocument(DocumentSnapshot doc)
      : date = (doc['date'] as Timestamp).toDate(),
        timeInterval = doc['timeInterval'] as String,
        userEmail = doc['userEmail'] as String;
}