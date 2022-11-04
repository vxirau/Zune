//FLUTTER NATIVE
import 'dart:math';
import 'package:flutter/cupertino.dart';

//SCREENS
import 'package:zune/src/screens/scanner_view/camera_view_singleton.dart';

//PAQUETS INSTALATS
import 'package:hive/hive.dart';

//ADAPTERS
part 'recognition.g.dart';

@HiveType(typeId: 0)
class Recognition extends HiveObject {
  @HiveField(0)
  int _id;

  @HiveField(1)
  String _label;

  @HiveField(2)
  double _score;

  @HiveField(3)
  int? type;

  @HiveField(4)
  String? action;

  Rect? _location;

  @HiveField(6)
  bool? isSaved;

  Recognition(this._id, this._label, this._score, [this._location, this.type]);

  int get id => _id;

  String get label => _label;

  double get score => _score;

  Rect? get location => _location;

  Rect get renderLocation {
    double ratioX = CameraViewSingleton.ratio;
    double ratioY = ratioX;

    if (location != null) {
      double transLeft = max(0.1, location!.left * ratioX);
      double transTop = max(0.1, location!.top * ratioY);
      double transWidth = min(location!.width * ratioX, CameraViewSingleton.actualPreviewSize.width);
      double transHeight = min(location!.height * ratioY, CameraViewSingleton.actualPreviewSize.height);
      Rect transformedRect = Rect.fromLTWH(transLeft, transTop, transWidth, transHeight);
      return transformedRect;
    } else {
      return Rect.fromCenter(center: Offset(0, -1), width: 100, height: 100);
    }
  }

  @override
  String toString() {
    return 'Recognition(id: $id, label: $label, score: $score, location: $location)';
  }
}
