import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubb_flutter_pt_app/pages/dashboard.dart';
import 'package:ubb_flutter_pt_app/pages/new-appointment.dart';
import 'package:ubb_flutter_pt_app/pages/user_profile.dart';
import 'package:ubb_flutter_pt_app/state/AuthProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'Trainer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      initialRoute: authProvider.isLoggedIn ? '/' : '/login',
      routes: {
        '/': (context) => const Dashboard(title: 'My trainings'),
        '/login': (context) => const LoginPage(),
        '/user-profile': (context) => const UserProfile(),
        '/new-appointment': (context) => const NewAppointment(),
      },
    );
  }
}
