import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/upload_screen.dart';
import '../screens/result_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/voice_input_screen.dart';
import '../screens/marketplace_screen.dart';
import '../screens/scan_document_screen.dart';
import '../screens/login_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String upload = '/upload';
  static const String result = '/result';
  static const String dashboard = '/dashboard';
  static const String voice = '/voice';
  static const String scan = '/scan';
  static const String marketplace = '/marketplace';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(isAdmin: false),
    home: (context) => const HomeScreen(),
    upload: (context) => const UploadScreen(),
    result: (context) => const ResultScreen(),
    dashboard: (context) => const DashboardScreen(),
    voice: (context) => const VoiceInputScreen(),
    scan: (context) => const ScanDocumentScreen(),
    marketplace: (context) => const MarketplaceScreen(),
  };
}
