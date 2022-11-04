import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart';

class LocProvider extends ChangeNotifier {
  Position? _currentPosition;

  Position? get getValuePosition {
    return _currentPosition;
  }

  Future<void> getCurrentPosition() async {
    final status = await Permission.location.status;
    LocationPermission permission;
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else if (status == PermissionStatus.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        openAppSettings();
      } else if (permission != LocationPermission.denied) {
        _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        notifyListeners();
      }
    } else if (status == PermissionStatus.granted) {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      notifyListeners();
    }
  }
}
