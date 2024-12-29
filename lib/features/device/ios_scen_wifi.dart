import 'package:flutter/services.dart';

class HotspotHelper {
  static const MethodChannel _channel = MethodChannel('hotspot_helper');

  static Future<void> registerHotspotHelper() async {
    try {
      await _channel.invokeMethod('registerHotspotHelper');
    } catch (e) {
      print("Error registering Hotspot Helper: $e");
    }
  }

  static Future<List<String>> scanNetworks() async {
    try {
      final List<dynamic> networks =
          await _channel.invokeMethod('scanNetworks');
      return networks.cast<String>();
    } catch (e) {
      print("Error scanning networks: $e");
      return [];
    }
  }
}
