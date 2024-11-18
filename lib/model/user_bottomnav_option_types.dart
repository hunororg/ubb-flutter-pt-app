import 'package:flutter/material.dart';
import 'package:ubb_flutter_pt_app/model/bottomnav_option_types.dart';

import '../pages/bottomnav_pages/bottomnav_dashboard.dart';
import '../pages/bottomnav_pages/bottomnav_history.dart';

class UserBottomNavOptionTypes {
  static BottomNavOptionTypes fromIndex(int index) {
    switch (index) {
      case 0:
        return BottomNavOptionTypes.home;
      case 1:
        return BottomNavOptionTypes.history;
      default:
        return BottomNavOptionTypes.home;
    }
  }

  static final Map<BottomNavOptionTypes, Widget> widgetOptions = {
    BottomNavOptionTypes.home: const BottomNavDashboard(),
    BottomNavOptionTypes.history: const BottomNavHistory(),
  };

  static final Map<BottomNavOptionTypes, String> widgetTitles = {
    BottomNavOptionTypes.home: 'Dashboard',
    BottomNavOptionTypes.history: 'History',
  };

  static const List<Widget> widgets = <Widget>[
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
  ];
}