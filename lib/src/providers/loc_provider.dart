import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:geolocator/geolocator.dart' as geo;

import 'package:permission_handler/permission_handler.dart';

class LocProvider extends ChangeNotifier {
  geo.Position? currentPosition;

  late StreamSubscription<geo.ServiceStatus> serviceStatusStream;

  LocProvider() {
    serviceStatusStream = geo.Geolocator.getServiceStatusStream().listen((geo.ServiceStatus status) {
      if (status == geo.ServiceStatus.disabled) {
        currentPosition = null;
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
        currentPosition = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
        notifyListeners();
      }
    } else if (status == PermissionStatus.granted) {
      currentPosition = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      notifyListeners();
    }
  }

  String generateStaticURL({required double width, required double height}) {
    Uri fUri;
    var baseUri = Uri(scheme: "https", host: "maps.googleapis.com", port: 443, path: "/maps/api/staticmap", queryParameters: {});

    fUri = baseUri.replace(queryParameters: {
      'map_id': FlutterConfig.get('MAPS_ID'),
      'autoscale': '2',
      'scale': '2',
      'size': '${width.floor()}x${height.floor()}',
      'key': FlutterConfig.get('MAPS_KEY'),
      'format': 'png',
      'zoom': '16',
      'center': "${currentPosition!.latitude},${currentPosition!.longitude}",
    });

    String tmp = "&markers=scale:2|color:0x8A66E6|label:X|${currentPosition!.latitude},${currentPosition!.longitude}";

    return "${fUri.toString()}$tmp";
  }
}
