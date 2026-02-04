import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const SmartFarmingApp());
}

class SmartFarmingApp extends StatelessWidget {
  const SmartFarmingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farming',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
