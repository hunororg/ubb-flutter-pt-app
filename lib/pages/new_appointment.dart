import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:ubb_flutter_pt_app/dao/appointment_dao.dart';
import 'package:ubb_flutter_pt_app/dao/session_type_dao.dart';
import 'package:ubb_flutter_pt_app/model/store/session_type.dart';
import 'package:ubb_flutter_pt_app/state/auth_provider.dart';

class NewAppointment extends StatefulWidget {
  const NewAppointment({super.key});

  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  List<SessionType> _sessionTypes = [];
  late SessionType _selectedSessionType;
  String? _selectedTimeInterval;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  final AppointmentDao _appointmentDao = AppointmentDao();
  final List<String> _timeIntervals = [];

  // Generate time intervals from 9:00 AM to 10:00 PM
  void _reloadTimeIntervals(DateTime selectedDate) {
    final List<String> intervals = [];

    DateTime startTime;
    if (selectedDate.day <= DateTime.now().day) {
      startTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, DateTime.now().hour + 1);
    } else {
      startTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 9);
    }

    DateTime endTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 22);

    while (startTime.isBefore(endTime)) {
      final end = startTime.add(const Duration(hours: 1));
      intervals.add('${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(end)}');
      startTime = end;
    }

    setState(() {
      _timeIntervals.clear();
      _timeIntervals.addAll(intervals);
    });

    intervals;
  }

  @override
  void initState() {
    super.initState();

    _reloadTimeIntervals(DateTime.now());
    _selectedTimeInterval = _timeIntervals.first; // Set the default interval

    _initSessionTypes();
  }

  @override
  Widget build(BuildContext context) {
    // Set the valid range for appointments (next 2 weeks)
    final DateTime firstDay = DateTime.now();
    final DateTime lastDay = DateTime.now().add(const Duration(days: 14));

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
              firstDay: firstDay,
              lastDay: lastDay,
              focusedDay: _focusedDate,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDate = focusedDay;

                  _reloadTimeIntervals(selectedDay);
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
              enabledDayPredicate: (day) =>
              (day.isAfter(firstDay.subtract(const Duration(days: 1))) &&
                  day.isBefore(lastDay.add(const Duration(days: 1)))) ||
                  isSameDay(day, firstDay),  // Allow today to be selected
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
            // Display selected date and time interval with basic framing and centered text
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${DateFormat('EEEE, yyyy-MM-dd').format(_selectedDate)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_selectedTimeInterval',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _appointmentDao.saveAppointment(
                      AuthProvider.userDataStatic!.email,
                      AuthProvider.userDataStatic!.name,
                      _selectedDate,
                      _selectedTimeInterval!,
                      _selectedSessionType
                  );

                  // Perform the action to save the selected date and time
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Appointment set for ${DateFormat('EEEE, yyyy-MM-dd').format(_selectedDate)} at $_selectedTimeInterval',
                      ),
                    ),
                  );

                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Make button larger
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Confirm Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initSessionTypes() async {
    final SessionTypeDao sessionTypeDao = SessionTypeDao();

    this._sessionTypes = await sessionTypeDao.getSessionTypes();
    if (_sessionTypes.isNotEmpty) {
      this._selectedSessionType = this._sessionTypes.first;
    }
  }
}
