import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubb_flutter_pt_app/model/store/session_type.dart';

import '../model/store/appointment.dart';

class AppointmentDao {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _appointmentsCollection = 'appointments';

  Future<List<Appointment>> getAppointmentsByUser(String userEmail) async {
    final querySnapshot = await _db
        .collection(_appointmentsCollection)
        .where('userEmail', isEqualTo: userEmail)
        .get();

    return querySnapshot.docs
        .map((doc) => Appointment.fromDocument(doc))
        .toList();
  }

  Future<void> saveAppointment(String userEmail, DateTime date,
      String timeInterval, SessionType sessionType) async {

    await _db.collection(_appointmentsCollection).add({
      'userEmail': userEmail,
      'date': date,
      'timeInterval': timeInterval,
      'sessionType': sessionType.toMap(),
    });
  }
}