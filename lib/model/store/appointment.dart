import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubb_flutter_pt_app/model/store/session_type.dart';

class Appointment {
  final DateTime date;
  final String timeInterval;
  final String userEmail;
  final String userName;
  final SessionType sessionType;

  Appointment(this.date, this.timeInterval, this.userEmail, this.userName,
      this.sessionType);

  Appointment.fromDocument(DocumentSnapshot doc) :
        date = DateTime.parse((doc['date'] as Timestamp).toDate().toString()),
        timeInterval = doc['timeInterval'],
        userEmail = doc['userEmail'],
        userName = doc['userName'],
        sessionType = SessionType.fromMap(doc['sessionType']);
}