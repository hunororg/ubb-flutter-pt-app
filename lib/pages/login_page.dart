import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubb_flutter_pt_app/model/login_method.dart';
import 'package:ubb_flutter_pt_app/state/AuthProvider.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(
            image: AssetImage('assets/images/logo.png'),
          )
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox.shrink(),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Training',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Workout trainings designed to help you achieve your fitness goals - whether losing weight or building muscle',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        authProvider.login(context, AuthMethod.google);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text('Sign in with Google'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        authProvider.login(context, AuthMethod.github);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text('Sign in with GitHub'),
                    ),
                  ],
                )
              ),
          ],
        ),
      ),
    );
  }
}