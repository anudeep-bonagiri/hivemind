// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ask for permission immediately
  await Geolocator.requestPermission();
  
  runApp(HiveMindApp());
}

class HiveMindApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HiveMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // Dark mode default
      home: DashboardScreen(),
    );
  }
}