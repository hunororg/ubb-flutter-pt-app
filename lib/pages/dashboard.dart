import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubb_flutter_pt_app/model/bottomnav_option_types.dart';
import 'package:ubb_flutter_pt_app/pages/bottomnav_pages/bottomnav_dashboard.dart';
import 'package:ubb_flutter_pt_app/pages/bottomnav_pages/bottomnav_history.dart';

import '../state/AuthProvider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.title});

  final String title;

  @override
  State<Dashboard> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Dashboard> {
  static final Map<BottomNavOptionTypes, Widget> _widgetOptions = {
    BottomNavOptionTypes.home: const BottomNavDashboard(),
    BottomNavOptionTypes.history: const BottomNavHistory(),
  };
  static final Map<BottomNavOptionTypes, String> _widgetTitles = {
    BottomNavOptionTypes.home: 'Dashboard',
    BottomNavOptionTypes.history: 'History',
  };

  int currentPageIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_widgetTitles[BottomNavOptionTypes.fromIndex(currentPageIndex)]!),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                  onPressed: () {
                    if (authProvider.isLoggedIn) {
                      Navigator.of(context).pushNamed('/user-profile');
                    }
                      // } else {
                    //   Navigator.of(context).pushNamed('/login');
                    // }
                  },
                  icon: const Icon(Icons.person));
            },
          )
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: _widgetOptions.values.toList(),
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
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'History of trainings',
          )
        ],
      ),
    );
  }
}

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dashboard(title: 'My trainings');
  }
}