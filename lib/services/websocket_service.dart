// lib/services/websocket_service.dart
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  // Connect to the Python Brain
  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(AppConstants.serverUrl));
      print("Connected to HiveMind Brain");
    } catch (e) {
      print("Connection Error: $e");
    }
  }

  // Send GPS Data (Lat, Lon, Speed)
  void sendLocationUpdate(double lat, double lon, double speed) {
    if (_channel != null) {
      final data = jsonEncode({
        "lat": lat,
        "lon": lon,
        "speed": speed, // Speed is in m/s
        "timestamp": DateTime.now().toIso8601String()
      });
      _channel!.sink.add(data);
    }
  }

  // Listen for "Pacer" commands
  Stream get stream {
    if (_channel == null) connect();
    return _channel!.stream;
  }

  void close() {
    _channel?.sink.close();
  }
}