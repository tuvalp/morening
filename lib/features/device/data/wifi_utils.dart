import 'dart:io';

import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';

class WifiUtils {
  Future<bool> _checkPermissions() async {
    if (Platform.isIOS || await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> connect(String ssid, String password) async {
    if (await _checkPermissions()) {
      try {
        final isConnected =
            await FlutterIotWifi.connect(ssid, password, prefix: true);

        if (isConnected == true) {
          print("Connection started successfully: $isConnected");
          return true;
        } else {
          print("Failed to start connection.");
          return false;
        }
      } catch (e) {
        print("Error during connection attempt: $e");
        return false;
      }
    } else {
      print("Don't have permission to connect.");
      return false;
    }
  }

  void disconnect() async {
    if (await _checkPermissions()) {
      FlutterIotWifi.disconnect()
          .then((value) => print("disconnect initiated: $value"));
    } else {
      print("don't have permission");
    }
  }

  void scan() async {
    if (await _checkPermissions()) {
      FlutterIotWifi.scan().then((value) => print("scan started: $value"));
    } else {
      print("don't have permission");
    }
  }

  void list() async {
    if (await _checkPermissions()) {
      FlutterIotWifi.list().then((value) => print("ssids: $value"));
    } else {
      print("don't have permission");
    }
  }

  void current() async {
    if (await _checkPermissions()) {
      FlutterIotWifi.current().then((value) => print("current ssid: $value"));
    } else {
      print("don't have permission");
    }
  }
}
