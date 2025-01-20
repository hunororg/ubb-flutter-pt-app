import 'package:flutter/material.dart';

import '../model/store/appointment.dart';

class AppointmentDetailed extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailed({super.key, required this.appointment});

  @override
  State<AppointmentDetailed> createState() => _AppointmentDetailedState();
}

class _AppointmentDetailedState extends State<AppointmentDetailed> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.appointment.date.toString()),
          ],
        ),
      )
    );
  }
}