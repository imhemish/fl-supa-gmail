import 'package:flutter/material.dart';

import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/deletion/deletion_page.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';

class RouteNames {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String deletion = '/deletion';
}

final Map<String, WidgetBuilder> appRoutes = {
  RouteNames.login: (context) => const LoginScreen(),
  RouteNames.home: (context) => const HomeScreen(),
  RouteNames.profile: (context) => const ProfilePage(),
  RouteNames.deletion: (context) => const DeletionPage(),
};