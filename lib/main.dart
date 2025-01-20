import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubb_flutter_pt_app/model/shared_pref_constants.dart';
import 'package:ubb_flutter_pt_app/pages/appointment_detailed.dart';
import 'package:ubb_flutter_pt_app/pages/dashboard.dart';
import 'package:ubb_flutter_pt_app/pages/new_appointment.dart';
import 'package:ubb_flutter_pt_app/pages/user_profile.dart';
import 'package:ubb_flutter_pt_app/state/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ubb_flutter_pt_app/state/navigation_service.dart';
import 'firebase_options.dart';

import 'model/store/appointment.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Read shared prefs
  final sharedPreferences = await SharedPreferences.getInstance();
  final authMethod = sharedPreferences.getString(authMethodKey);
  final idToken = sharedPreferences.getString(idTokenKey);
  final accessToken = sharedPreferences.getString(accessTokenKey);

  if (!(idToken != null && accessToken != null && authMethod != null)) {
    FlutterNativeSplash.remove();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) =>
        (idToken != null && accessToken != null && authMethod != null)
          ? AuthProvider.withAuthenticated(authMethod, accessToken, idToken)
          : AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trainer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/login',
      routes: {
        '/': (context) => const Dashboard(title: 'My trainings'),
        '/login': (context) => const LoginPage(),
        '/user-profile': (context) => const UserProfile(),
        '/new-appointment': (context) => const NewAppointment(),
      },
    );
  }
}
