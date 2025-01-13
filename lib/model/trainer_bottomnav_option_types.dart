import 'package:flutter/material.dart';
import 'package:ubb_flutter_pt_app/pages/bottomnav_pages/bottomnav_admin_dashboard.dart';
import 'package:ubb_flutter_pt_app/pages/user_profile.dart';

import '../pages/bottomnav_pages/bottomnav_statistics.dart';
import 'bottomnav_option_types.dart';

class TrainerBottomNavOptionTypes {
  static BottomNavOptionTypes fromIndex(int index) {
    switch (index) {
      case 0:
        return BottomNavOptionTypes.home;
      case 1:
        return BottomNavOptionTypes.statistics;
      case 2:
        return BottomNavOptionTypes.profile;
      default:
        return BottomNavOptionTypes.home;
    }
  }

  static final Map<BottomNavOptionTypes, Widget> widgetOptions = {
    BottomNavOptionTypes.home: const BottomNavAdminDashboard(),
    BottomNavOptionTypes.statistics: const BottomNavStatistics(),
    BottomNavOptionTypes.profile: const UserProfile(),
  };

  static final Map<BottomNavOptionTypes, String> widgetTitles = {
    BottomNavOptionTypes.home: 'Dashboard',
    BottomNavOptionTypes.statistics: 'Statistics',
    BottomNavOptionTypes.profile: 'Profile',
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
    NavigationDestination(
      selectedIcon: Icon(Icons.person),
      icon: Icon(Icons.person_outline),
      label: 'Profile',
    )
  ];
}