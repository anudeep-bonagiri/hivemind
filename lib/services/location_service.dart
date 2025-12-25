import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Stream that yields the user's position every few seconds
  Stream<Position> getPositionStream() {
    // Settings: High accuracy, update every 5 meters
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, 
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // Check and Request Permissions
  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Is GPS turned on?
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // GPS is off
    }

    // 2. Do we have permission?
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false; // User said no
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false; // User said "Never ask again"
    }

    return true; // We are good to go
  }
}