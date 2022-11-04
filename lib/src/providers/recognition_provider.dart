import 'package:flutter/material.dart';
import 'package:zune/src/db/boxes.dart';
import 'package:zune/src/models/tflite/recognition.dart';

class RecognitionProvider extends ChangeNotifier {
  List<Recognition> recognitions = [];
  final db = Boxes.getRecognition();

  Future<void> getAllRecognitions() async {
    if (db.isNotEmpty) {
      recognitions = db.values.toList().cast<Recognition>();
      notifyListeners();
    } else {
      print("DB ESTA BUIDA");
    }
  }

  void addRecognition(Recognition recognition) {
    print("GUARDEM OBJECTE RECOGNITION");
    recognition.isSaved = true;
    recognitions.add(recognition);
    //db.add(recognition);
    db.put(recognition.id, recognition);
    notifyListeners();
  }

  void updateRecognition(Recognition recognition) {
    for (int i = 0; i < recognitions.length; i++) {
      if (recognitions[i].label == recognition.label) {
        recognitions[i] = recognition;
        db.putAt(i, recognition);
        notifyListeners();
        break;
      }
    }
    notifyListeners();
  }

  void removeRecognition(Recognition recognition) {
    recognitions.remove(recognition);
    db.delete(recognition);
    notifyListeners();
  }

  void clearRecognitions() {
    recognitions.clear();
    db.clear();
    notifyListeners();
  }
}
