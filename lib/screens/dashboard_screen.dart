// lib/screens/dashboard_screen.dart
//import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/websocket_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final WebSocketService _socketService = WebSocketService();
  
  // Dashboard State
  String _statusMessage = "CALIBRATING FLOW";
  double _targetSpeed = 0.0; // In MPH
  double _currentSpeed = 0.0; // In MPH
  Color _statusColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable(); // Keep screen ON
    _socketService.connect();
    _startLocationUpdates();
    _listenToBrain();
  }

  // 1. Get Real GPS Data
  void _startLocationUpdates() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Update every 5 meters
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      
      // Update UI
      setState(() {
        _currentSpeed = position.speed * 2.23694; // Convert m/s to mph
      });

      // Send to Python Brain
      _socketService.sendLocationUpdate(
        position.latitude, 
        position.longitude, 
        position.speed
      );
    });
  }

  // 2. Receive Commands from Python
  void _listenToBrain() {
    _socketService.stream.listen((message) {
      final data = jsonDecode(message);
      setState(() {
        _targetSpeed = (data['target_speed'] as num).toDouble();
        _statusMessage = data['reason'];
        
        // Change color based on urgency
        if (_statusMessage.contains("Jam")) {
          _statusColor = Colors.redAccent;
        } else {
          _statusColor = Colors.greenAccent;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Status
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              color: _statusColor.withOpacity(0.2),
              child: Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: _statusColor
                ),
              ),
            ),
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("TARGET FLOW", style: TextStyle(color: Colors.grey, fontSize: 18)),
                  Text(
                    "${_targetSpeed.toInt()}",
                    style: GoogleFonts.rajdhani(
                      fontSize: 120, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                  ),
                  Text("MPH", style: TextStyle(color: Colors.grey, fontSize: 24)),
                  
                  SizedBox(height: 50),
                  
                  // Small Current Speed Indicator
                  Text("YOUR SPEED: ${_currentSpeed.toInt()}", 
                    style: TextStyle(color: Colors.grey[700], fontSize: 20)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}