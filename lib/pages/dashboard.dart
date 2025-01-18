import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubb_flutter_pt_app/model/bottomnav_option_types.dart';
import 'package:ubb_flutter_pt_app/model/trainer_bottomnav_option_types.dart';
import 'package:ubb_flutter_pt_app/model/user_bottomnav_option_types.dart';
import 'package:ubb_flutter_pt_app/model/user_role.dart';

import '../state/auth_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.title});

  final String title;

  @override
  State<Dashboard> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Dashboard> {
  int currentPageIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  Map<BottomNavOptionTypes, Widget> getWidgetOptions(AuthProvider authProvider) {
    if (authProvider.userData?.userRole == UserRole.trainer) {
      return TrainerBottomNavOptionTypes.widgetOptions;
    }
    return UserBottomNavOptionTypes.widgetOptions;
  }

  List<Widget> getWidgets(AuthProvider authProvider) {
    if (authProvider.userData?.userRole == UserRole.trainer) {
      return TrainerBottomNavOptionTypes.widgets;
    }
    return UserBottomNavOptionTypes.widgets;
  }

  String getTitle(AuthProvider authProvider) {
    if (authProvider.userData?.userRole == UserRole.trainer) {
      return TrainerBottomNavOptionTypes.widgetTitles[TrainerBottomNavOptionTypes.fromIndex(currentPageIndex)]!;
    }
    return UserBottomNavOptionTypes.widgetTitles[UserBottomNavOptionTypes.fromIndex(currentPageIndex)]!;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final Map<BottomNavOptionTypes, Widget> widgetOptions =
      getWidgetOptions(authProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(getTitle(authProvider),
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      extendBodyBehindAppBar: true,
      body: Column( // Use a Column instead of a Stack
        children: [
          Container(
            height: 0.2 * MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dashboard.png'),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight, // Align image to the right
              ),
            ),
          ),
          Expanded( // Use Expanded to fill the remaining space
            child: IndexedStack(
              index: currentPageIndex,
              children: widgetOptions.values.toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/new-appointment');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          _onItemTapped(index);
        },
        destinations: getWidgets(authProvider),
      ),
    );
  }
}