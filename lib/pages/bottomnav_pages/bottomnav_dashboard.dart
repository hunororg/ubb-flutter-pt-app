import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/training_session.dart';

class BottomNavDashboard extends StatelessWidget {
  const BottomNavDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final upcomingSessions = [
      TrainingSession(
        title: 'Pull workout',
        location: '18 Gym',
        trainerName: 'Asztalos Levente',
        dateTime: DateTime.now().add(Duration(days: 2)),
      ),
      TrainingSession(
        title: 'Push workout',
        location: 'REVO Gym',
        trainerName: 'Asztalos Levente',
        dateTime: DateTime.now().add(Duration(days: 5)),
      ),
      TrainingSession(
        title: 'Leg workout',
        location: '18 Gym',
        trainerName: 'Asztalos Levente',
        dateTime: DateTime.now().add(Duration(days: 7)),
      ),
      TrainingSession(
        title: 'Pull workout',
        location: 'REVO Gym',
        trainerName: 'Asztalos Levente',
        dateTime: DateTime.now().add(Duration(days: 11)),
      ),
      // Add more upcoming sessions as needed
    ];

    final pastSessions = [
      TrainingSession(
        title: 'Pull workout',
        location: '18 Gym',
        trainerName: 'Asztalos Levente',
        dateTime: DateTime.now().add(Duration(days: 2)),
      ),
      TrainingSession(
        title: 'Push workout',
        location: 'REVO Gym',
        trainerName: 'Asztalos Levente',
        dateTime: DateTime.now().add(Duration(days: 5)),
      ),
      TrainingSession(
        title: 'Leg workout',
        location: '18 Gym',
        trainerName: 'Asztalos Levente',
        dateTime: DateTime.now().add(Duration(days: 7)),
      ),
      // Add more past sessions as needed
    ];

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _buildSection('Upcoming Training Sessions', upcomingSessions, '/allUpcoming', true),
            _buildSection('Past Training Sessions', pastSessions, '/allPast', false),
          ],
        )
      ),
    );
  }

  Widget _buildSection(String title, List<TrainingSession> sessions, String seeAllRoute, bool future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 270, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sessions.length + (sessions.length > 2 ? 1 : 0), // Add "See all" button
            itemBuilder: (context, index) {
              if (index < sessions.length) {
                return _buildTrainingCard(sessions[index], future);
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

  Widget _buildTrainingCard(TrainingSession session, bool future) {
    return Container(
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
        width: 300, // Adjust width as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://media.istockphoto.com/id/625739874/ro/fotografie/exercitii-grele-de-greutate.jpg?s=1024x1024&w=is&k=20&c=t56T-dIE5s4MrdHdwnfw4DCNzI_TmnKKYCZOOlRD6Ns=',
              height: 120,
              width: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'with ${session.trainerName}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(session.location),
                  Text(DateFormat('EEE, MMM d, yyyy - hh:mm a').format(session.dateTime)),
                ],
              ),
            ),
          ],
        ),
      ),
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
}