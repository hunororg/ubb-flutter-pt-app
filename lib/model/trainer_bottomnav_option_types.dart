import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubb_flutter_pt_app/pages/bottomnav_pages/bottomnav_admin_dashboard.dart';

import '../pages/bottomnav_pages/bottomnav_dashboard.dart';
import '../pages/bottomnav_pages/bottomnav_history.dart';
import 'bottomnav_option_types.dart';

class TrainerBottomNavOptionTypes {
  static BottomNavOptionTypes fromIndex(int index) {
    switch (index) {
      case 0:
        return BottomNavOptionTypes.home;
      case 1:
        return BottomNavOptionTypes.history;
      case 2:
        return BottomNavOptionTypes.adminHome;
      default:
        return BottomNavOptionTypes.home;
    }
  }

  static final Map<BottomNavOptionTypes, Widget> widgetOptions = {
    BottomNavOptionTypes.home: const BottomNavDashboard(),
    BottomNavOptionTypes.history: const BottomNavHistory(),
    BottomNavOptionTypes.adminHome: const BottomNavAdminDashboard(),
  };

  static final Map<BottomNavOptionTypes, String> widgetTitles = {
    BottomNavOptionTypes.home: 'Dashboard',
    BottomNavOptionTypes.history: 'History',
    BottomNavOptionTypes.adminHome: 'Trainer Dashboard',
  };

  static final List<Widget> widgets = const <Widget>[
    NavigationDestination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Dashboard',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.calendar_month),
      icon: Icon(Icons.calendar_month_outlined),
      label: 'History of trainings',
    ),
    NavigationDestination(
        selectedIcon: Icon(Icons.admin_panel_settings),
        icon: Icon(Icons.admin_panel_settings_outlined),
        label: 'Trainer Dashboard'
    )
  ];
}