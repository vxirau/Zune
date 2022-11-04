import 'package:hive_flutter/hive_flutter.dart';
import 'package:zune/src/models/tflite/recognition.dart';

class Boxes {
  static Box<Recognition> getRecognition() => Hive.box<Recognition>('recognition');
}
