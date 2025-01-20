import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ubb_flutter_pt_app/dao/appointment_dao.dart';
import 'package:ubb_flutter_pt_app/pages/appointment_detailed.dart';
import 'package:ubb_flutter_pt_app/state/auth_provider.dart';

import '../../model/store/appointment.dart';

class BottomNavDashboard extends StatefulWidget {
  const BottomNavDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _BottomNavDashboardState();
}

class _BottomNavDashboardState extends State<BottomNavDashboard> {
  List<Appointment> upcomingAppointments = [];
  List<Appointment> pastAppointments = [];

  @override
  void initState() {
    super.initState();

    initUpcomingAppointments();
  }

  Future<void> initUpcomingAppointments() async {
    final String userEmail = AuthProvider.userDataStatic!.email;
    final AppointmentDao appointmentDao = AppointmentDao();

    final List<Appointment> appointments = await appointmentDao
        .getAppointmentsByUser(userEmail);

    // Initialize upcoming appointments
    List<Appointment> upcomingAppointments = appointments
        .where((appointment) => appointment.date.isAfter(DateTime.now()))
        .toList();
    upcomingAppointments.sort((a, b) => a.date.compareTo(b.date));

    // Initialize past appointments
    List<Appointment> pastAppointments = appointments
        .where((appointment) => appointment.date.isBefore(DateTime.now()))
        .toList();
    pastAppointments.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      this.upcomingAppointments = upcomingAppointments;
      this.pastAppointments = pastAppointments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              _buildSection('Upcoming Training Sessions', upcomingAppointments, '/allUpcoming', true),
              _buildSection('Past Training Sessions', pastAppointments, '/allPast', false),
            ],
          )
      ),
    );
  }

  Widget _buildSection(String title, List<Appointment> appointments,
      String seeAllRoute, bool future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 300, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: appointments.length + (appointments.length > 2 ? 1 : 0), // Add "See all" button
            itemBuilder: (context, index) {
              if (index < appointments.length) {
                return _buildTrainingCard(appointments[index], future);
              } else {
                String buttonText = future ? "All future sessions >" : "All past sessions >";
                return _buildSeeAllButton(context, buttonText, seeAllRoute);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingCard(Appointment appointment, bool future) {
    return GestureDetector(
        onTap: () {
      // Navigate to the detailed view of the appointment
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          AppointmentDetailed(appointment: appointment)));
    },
    child:
      Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: !future ? Colors.green : Colors.transparent,
              width: 5,
            ),
          ),
        ),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: SizedBox(
            width: 340, // Adjust width as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://media.istockphoto.com/id/1277242852/photo/holding-weight-and-sitting.jpg?s=612x612&w=0&k=20&c=3sy-VVhUYjABpNEMI2aoruXQuOVb__-AUR6BzOHoSJg=',
                  height: 150,
                  width: 340,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.sessionType.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'with ${appointment.sessionType.trainerName}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(appointment.sessionType.location),
                      Text("${DateFormat('EEE, MMM d, yyyy').format(appointment.date)} between ${appointment.timeInterval}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  Widget _buildSeeAllButton(BuildContext context, String buttonText, String route) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(buttonText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // DONT REMOVE THIS,MIGHT BE NEEDED
  // Future<bool> waitForConditionWithAbortCondition(
  //     bool Function() fulfillmentCondition,
  //     bool Function() instantAbortCondition,
  //     {Duration checkInterval = const Duration(milliseconds: 200),
  //       Duration timeout = const Duration(seconds: 30)}) async {
  //   bool response = true;
  //   bool done = false;
  //   Future.delayed(
  //     timeout,
  //         () {
  //       response = false;
  //       done = true;
  //     },
  //   );
  //   while (!fulfillmentCondition()) {
  //     await Future.delayed(checkInterval);
  //     if (done || instantAbortCondition()) {
  //       break;
  //     }
  //   }
  //   return response;
  // }
}