import 'package:flutter/material.dart';
import '../model/store/appointment.dart';


class AppointmentDetailed extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailed({super.key, required this.appointment});

  @override
  State<AppointmentDetailed> createState() => _AppointmentDetailedState();
}

class _AppointmentDetailedState extends State<AppointmentDetailed> {
  bool isSyncing = false;

  Future<void> syncToGoogleCalendar() async {
    setState(() {
      isSyncing = true;
    });

    try {
      // Replace with actual Google Calendar API sync logic
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment synced to Google Calendar!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sync: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: 0.15 * constraints.maxHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/dashboard.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Appointment Details',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _header('Appointment Information'),
                      const SizedBox(height: 16),
                      _detailItem('Date', appointment.date.toLocal().toString().split(' ')[0]),
                      _detailItem('Time Interval', appointment.timeInterval),
                      _detailItem('User Email', appointment.userEmail),
                      _detailItem('User Name', appointment.userName),
                      const Spacer(),
                      Center(
                        child: ElevatedButton(
                          onPressed: isSyncing ? null : syncToGoogleCalendar,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            backgroundColor: isSyncing ? Colors.grey : Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isSyncing
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'Sync to Google Calendar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade600,
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.orange.shade600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
