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

    final List<Appointment> appointments =
    await appointmentDao.getAppointmentsByUser(userEmail);

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
    final String? userName = AuthProvider.userDataStatic?.name;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            if (userName != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Hello, $userName!',
                  style: const TextStyle(
                    fontSize: 29, // Adjusted for smaller size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            _buildSection('Upcoming Training Sessions', upcomingAppointments,
                '/allUpcoming', true),
            _buildSection('Past Training Sessions', pastAppointments,
                '/allPast', false),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Appointment> appointments,
      String seeAllRoute, bool future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 24, // Adjusted for smaller size
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 270, // Reduced height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: appointments.length + (appointments.length > 2 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < appointments.length) {
                return _buildTrainingCard(appointments[index], future);
              } else {
                String buttonText = future
                    ? "All future sessions >"
                    : "All past sessions >";
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AppointmentDetailed(appointment: appointment)));
        },
        child: Container(
            margin: const EdgeInsets.all(8.0), // Reduced margin for better layout
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: !future ? Colors.green : Colors.transparent,
                  width: 3, // Reduced width of the border
                ),
              ),
            ),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: SizedBox(
                width: 300, // Adjusted width to prevent overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://media.istockphoto.com/id/1277242852/photo/holding-weight-and-sitting.jpg?s=612x612&w=0&k=20&c=3sy-VVhUYjABpNEMI2aoruXQuOVb__-AUR6BzOHoSJg=',
                      height: 120, // Reduced height
                      width: 300, // Adjusted width
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.sessionType.title,
                            style: const TextStyle(
                                fontSize: 16, // Reduced font size
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'with ${appointment.sessionType.trainerName}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(appointment.sessionType.location),
                          Text(
                              "${DateFormat('EEE, MMM d, yyyy').format(appointment.date)} between ${appointment.timeInterval}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget _buildSeeAllButton(
      BuildContext context, String buttonText, String route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(buttonText,
            style: const TextStyle(
                fontSize: 16, // Adjusted font size
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
