//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

//MODELS
import 'package:zune/src/models/tflite/recognition.dart';

//PAQUETS INSTALATS
import 'package:image/image.dart' as imageLib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:zune/src/models/utilities/string_extension.dart';

import 'stats.dart';

class Classifier {
  late Interpreter _interpreter;
  late List<String> _labels;

  static const String MODEL_FILE_NAME = "prova.tflite";
  static const String LABEL_FILE_NAME = "coco.txt";

  static const int INPUT_SIZE = 320;

  /// Result score threshold
  static const double THRESHOLD = 0.3;

  ImageProcessor? imageProcessor;
  late int padSize;

  List<List<int>> _outputShapes = [];
  List<TfLiteType> _outputTypes = [];

  static const int NUM_RESULTS = 40;

  Classifier({
    required Interpreter? interpreter,
    required List<String> labels,
  }) {
    loadModel(interpreter: interpreter);
    loadLabels(labels: labels);
  }

  void loadModel({required Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            MODEL_FILE_NAME,
            options: InterpreterOptions()..threads = 4,
          );

      var outputTensors = _interpreter.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      outputTensors.forEach((tensor) {
        _outputShapes.add(tensor.shape);
        _outputTypes.add(tensor.type);
      });
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  void loadLabels({required List<String> labels}) async {
    try {
      _labels = labels.isEmpty ? await FileUtil.loadLabels("assets/" + LABEL_FILE_NAME) : labels;
    } catch (e) {
      print("Error while loading labels: $e");
    }
  }

  /// Pre-process the image
  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width);
    if (imageProcessor == null) {
      imageProcessor = ImageProcessorBuilder().add(ResizeWithCropOrPadOp(padSize, padSize)).add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR)).build();
    }
    inputImage = imageProcessor!.process(inputImage);
    return inputImage;
  }

  /// Runs object detection on the input image
  Map<String, dynamic> predict(imageLib.Image image) {
    var predictStartTime = DateTime.now().millisecondsSinceEpoch;

    if (_interpreter == null) {
      print("Interpreter not initialized");
      return {};
    }

    var preProcessStart = DateTime.now().millisecondsSinceEpoch;

    // Create TensorImage from image
    TensorImage inputImage = TensorImage.fromImage(image);

    // Pre-process TensorImage
    inputImage = getProcessedImage(inputImage);

    var preProcessElapsedTime = DateTime.now().millisecondsSinceEpoch - preProcessStart;

    // TensorBuffers for output tensors
    TensorBuffer outputLocations = TensorBufferFloat(_outputShapes[0]);
    TensorBuffer outputClasses = TensorBufferFloat(_outputShapes[1]);
    TensorBuffer outputScores = TensorBufferFloat(_outputShapes[2]);
    TensorBuffer numLocations = TensorBufferFloat(_outputShapes[3]);

    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    List<Object> inputs = [inputImage.buffer];

    // Outputs map
    Map<int, Object> outputs = {
      0: outputLocations.buffer,
      1: outputClasses.buffer,
      2: outputScores.buffer,
      3: numLocations.buffer,
    };

    var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;

    _interpreter.runForMultipleInputs(inputs, outputs);

    var inferenceTimeElapsed = DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;

    // Maximum number of results to show
    int resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));

    // Using labelOffset = 1 as ??? at index 0
    int labelOffset = 1;

    // Using bounding box utils for easy conversion of tensorbuffer to List<Rect>
    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [1, 0, 3, 2],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );

    List<Recognition> recognitions = [];

    for (int i = 0; i < resultsCount; i++) {
      // Prediction score
      var score = outputScores.getDoubleValue(i);

      // Label string
      var labelIndex = outputClasses.getIntValue(i) + labelOffset;
      String label = _labels.elementAt(labelIndex);
      label = label.capitalize();

      if (score > THRESHOLD) {
        Rect transformedRect = imageProcessor!.inverseTransformRect(locations[i], image.height, image.width);

        recognitions.add(
          Recognition(i, label, score, transformedRect),
        );
      }
    }

    var predictElapsedTime = DateTime.now().millisecondsSinceEpoch - predictStartTime;

    return {"recognitions": recognitions, "stats": Stats(totalPredictTime: predictElapsedTime, inferenceTime: inferenceTimeElapsed, preProcessingTime: preProcessElapsedTime, totalElapsedTime: predictElapsedTime)};
  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter;

  /// Gets the loaded labels
  List<String> get labels => _labels;
}
