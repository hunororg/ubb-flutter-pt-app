import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ubb_flutter_pt_app/model/store/appointment.dart';
import 'package:ubb_flutter_pt_app/state/auth_provider.dart';

import '../../dao/appointment_dao.dart';

class BottomNavAdminDashboard extends StatefulWidget {
  const BottomNavAdminDashboard({super.key});

  @override
  State<BottomNavAdminDashboard> createState() => _BottomNavAdminDashboardState();
}

class _BottomNavAdminDashboardState extends State<BottomNavAdminDashboard> {
  List<Appointment> _appointments = [];
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  final AppointmentDao _appointmentDao = AppointmentDao();

  @override
  void initState() {
    super.initState();
    _loadAppointmentsForSelectedDate(_selectedDate,
        AuthProvider.userDataStatic!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
                focusedDay: _focusedDate,
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 21)),
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                enabledDayPredicate: (day) => true,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDate = selectedDay;
                  });
                  _loadAppointmentsForSelectedDate(selectedDay,
                      AuthProvider.userDataStatic!.email);
                },
                calendarFormat: CalendarFormat.week,
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  disabledDecoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _appointments.isEmpty ? Colors.orange.shade100 : Colors.blue.shade50,  // Example: Error alert
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _appointments.isEmpty ? "You don't have any appointments this day!"
                : "You have ${_appointments.length} appointments this day!",
                style: TextStyle(color: _appointments.isEmpty ? Colors.blue.shade900 : Colors.blue.shade800,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 0.0),
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final appointment = _appointments[index];
                  return _buildAppointmentCard(appointment,
                      appointment.date.isBefore(DateTime.now()));
                },
              ),
            ),
          ]
        )
      )
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, bool past) {
    return Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: past ? Colors.red : Colors.green,
              width: 5,
            ),
          ),
        ),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://images.pexels.com/photos/1954524/pexels-photo-1954524.jpeg?cs=srgb&dl=pexels-willpicturethis-1954524.jpg&fm=jpg',
                  height: 170,
                  width: 385,
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
                        'with ${appointment.userName}',
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
    );
  }

  Future<void> _loadAppointmentsForSelectedDate(DateTime selectedDate,
      String trainerEmail) async {
    final appointments = await _appointmentDao.getAppointmentsForDateAndTrainer(selectedDate,
        trainerEmail);
    setState(() {
      this._appointments = appointments;
    });
  }
}