import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart' as geo;

import 'package:permission_handler/permission_handler.dart';

class LocProvider extends ChangeNotifier {
  geo.Position? _currentPosition;

  geo.Position? get getValuePosition {
    return _currentPosition;
  }

  late StreamSubscription<geo.ServiceStatus> serviceStatusStream;

  LocProvider() {
    serviceStatusStream = geo.Geolocator.getServiceStatusStream().listen((geo.ServiceStatus status) {
      if (status == geo.ServiceStatus.disabled) {
        _currentPosition = null;
        notifyListeners();
      } else if (status == geo.ServiceStatus.enabled) {
        try {
          getCurrentPosition().then((value) => notifyListeners());
        } catch (e) {}
      }
    });
  }

  @override
  void dispose() {
    serviceStatusStream.cancel();
    super.dispose();
  }

  Future<void> getCurrentPosition() async {
    final status = await Permission.location.status;
    geo.LocationPermission permission;
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else if (status == PermissionStatus.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.deniedForever) {
        openAppSettings();
      } else if (permission != geo.LocationPermission.denied) {
        _currentPosition = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
        notifyListeners();
      }
    } else if (status == PermissionStatus.granted) {
      _currentPosition = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      notifyListeners();
    }
  }
}
