import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubb_flutter_pt_app/extensions/string_extensions.dart';

import '../state/AuthProvider.dart' as local_auth_provider; // my auth provider

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authProvider = Provider.of<local_auth_provider.AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding( // Add Padding here
        padding: const EdgeInsets.only(top: 18.0), // Adjust padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (user != null) ...[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL ?? ''),
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName ?? 'N/A',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                authProvider.userData?.email ?? 'N/A',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Role: ${authProvider.userData?.userRole.value.capitalize()
                    ?? 'N/A'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.local_offer),
                title: const Text('Manage training package',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                onTap: () {
                  // Handle navigation or action here
                  // For example, navigate to a new screen:
                  Navigator.pushNamed(context, '/modifyTrainingOffering');
                },
                trailing: const Icon(Icons.edit),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.person_4),
                title: const Text('Manage account details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                onTap: () {
                  // Handle navigation or action here
                  // For example, navigate to a new screen:
                  Navigator.pushNamed(context, '/modifyTrainingOffering');
                },
                trailing: const Icon(Icons.edit),
              ),
              const Divider(height: 0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Sign out logic
                  FirebaseAuth.instance.signOut();
                  authProvider.logout();
                  // Navigate back to login or home screen
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            ] else ...[
              const Text('User not logged in.'),
            ],
          ],
        ),
      ),
    )
    );
  }
}