

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart';



class LocProvider extends ChangeNotifier {

  Position? _currentPosition;

  Position? get getValuePosition{ 
      return _currentPosition;
  }

  Future<void>  getCurrentPosition() async {
    final status = await Permission.location.status;
    LocationPermission permission;
    if (status == PermissionStatus.permanentlyDenied) {
     log("1");
      openAppSettings();
    } else if (status == PermissionStatus.denied) {
      log("2");
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever){
        log("3");
        openAppSettings();
      } else if(permission != LocationPermission.denied){
        log("4");
        _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      notifyListeners();

      }
    } else if (status == PermissionStatus.granted) {
      log("5");
        _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      notifyListeners();
    }
}

}