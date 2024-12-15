import 'package:flutter/material.dart';
import 'package:ubb_flutter_pt_app/pages/bottomnav_pages/bottomnav_admin_dashboard.dart';

import '../pages/bottomnav_pages/bottomnav_statistics.dart';
import 'bottomnav_option_types.dart';

class TrainerBottomNavOptionTypes {
  static BottomNavOptionTypes fromIndex(int index) {
    switch (index) {
      case 0:
        return BottomNavOptionTypes.home;
      case 1:
        return BottomNavOptionTypes.statistics;
      default:
        return BottomNavOptionTypes.home;
    }
  }

  static final Map<BottomNavOptionTypes, Widget> widgetOptions = {
    BottomNavOptionTypes.home: const BottomNavAdminDashboard(),
    BottomNavOptionTypes.statistics: const BottomNavStatistics(),
  };

  static final Map<BottomNavOptionTypes, String> widgetTitles = {
    BottomNavOptionTypes.home: 'Dashboard',
    BottomNavOptionTypes.statistics: 'Statistics',
  };

  static const List<Widget> widgets = <Widget>[
    NavigationDestination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Dashboard',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.area_chart),
      icon: Icon(Icons.area_chart_outlined),
      label: 'Statistics',
    ),
  ];
}