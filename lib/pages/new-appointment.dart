import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:ubb_flutter_pt_app/dao/appointment_dao.dart';
import 'package:ubb_flutter_pt_app/state/AuthProvider.dart';

class NewAppointment extends StatefulWidget {
  const NewAppointment({super.key});

  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  String? _selectedTimeInterval;
  final AppointmentDao _appointmentDao = AppointmentDao();

  // Generate time intervals from 9:00 AM to 10:00 PM
  List<String> get _timeIntervals {
    final List<String> intervals = [];
    DateTime startTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 9);
    DateTime endTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 22);

    while (startTime.isBefore(endTime)) {
      final end = startTime.add(const Duration(hours: 1));
      intervals.add('${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(end)}');
      startTime = end;
    }
    return intervals;
  }

  @override
  void initState() {
    super.initState();
    _selectedTimeInterval = _timeIntervals.first; // Set the default interval
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(2100),
              focusedDay: _focusedDate,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                if (selectedDay.isBefore(DateTime.now())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot select past dates!')),
                  );
                  return;
                }
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDate = focusedDay;
                  _selectedTimeInterval = _timeIntervals.first; // Reset time interval on date change
                });
              },
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
              enabledDayPredicate: (day) => day.isAfter(DateTime.now().subtract(const Duration(days: 1))),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a Time Interval:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedTimeInterval,
              items: _timeIntervals
                  .map((time) => DropdownMenuItem(
                value: time,
                child: Text(time),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTimeInterval = value;
                });
              },
              isExpanded: true,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _appointmentDao.saveAppointment(AuthProvider.userDataStatic!.email, _selectedDate, _selectedTimeInterval!);

                // Perform the action to save the selected date and time
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Appointment set for ${_selectedDate.toLocal().toString().split(' ')[0]} at $_selectedTimeInterval',
                    ),
                  ),
                );

                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: const Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
