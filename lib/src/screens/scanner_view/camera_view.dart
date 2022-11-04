//FLUTTER NATIVE
import 'dart:isolate';
import 'package:flutter/material.dart';

//PAQUETS INSTALATS
import 'package:camera/camera.dart';

//MODELS
import 'package:zune/src/models/models.dart';

//SCREENS
import 'package:zune/src/screens/scanner_view/camera_view_singleton.dart';

/// [CameraView] sends each frame for inference
class CameraView extends StatefulWidget {
  final Function(List<Recognition> recognitions) resultsCallback;
  final Function(Stats stats) statsCallback;

  const CameraView(this.resultsCallback, this.statsCallback);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  /// List of available cameras
  late List<CameraDescription> cameras = [];

  /// Controller
  CameraController? cameraController;

  /// true when inference is ongoing
  late bool predicting;

  /// Instance of [Classifier]
  late Classifier classifier;

  /// Instance of [IsolateUtils]
  late IsolateUtils isolateUtils;

  @override
  void initState() {
    initStateAsync();
    super.initState();
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);

    isolateUtils = IsolateUtils();
    await isolateUtils.start();
    await initializeCamera();

    //TODO: REVISAR AIXÒ PERQUE NO TINC NI IDEA DE COM FUNCIONA
    classifier = Classifier(interpreter: null, labels: []);

    predicting = false;
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

    if (mounted) {
      cameraController!.initialize().then((_) async {
        if (mounted) {
          await cameraController!.startImageStream(onLatestImageAvailable);
          Size previewSize = cameraController!.value.previewSize == null ? MediaQuery.of(context).size : cameraController!.value.previewSize!;

          CameraViewSingleton.inputImageSize = previewSize;
          Size screenSize = MediaQuery.of(context).size;
          CameraViewSingleton.screenSize = screenSize;
          CameraViewSingleton.ratio = screenSize.width / previewSize.height;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || cameraController!.value.isInitialized == false) {
      return Container();
    }

    double scale = 1 / (cameraController!.value.aspectRatio * MediaQuery.of(context).size.aspectRatio);
    print(scale);
    return Transform.scale(scale: scale, alignment: Alignment.center, child: CameraPreview(cameraController!));
  }

  onLatestImageAvailable(CameraImage cameraImage) async {
    if (classifier.interpreter != null && classifier.labels != null) {
      if (predicting) {
        return;
      }

      if (mounted) {
        setState(() {
          predicting = true;
        });
        var uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;

        // Data to be passed to inference isolate
        var isolateData = IsolateData(cameraImage, classifier.interpreter.address, classifier.labels);

        // We could have simply used the compute method as well however
        // it would be as in-efficient as we need to continuously passing data
        // to another isolate.

        /// perform inference in separate isolate
        Map<String, dynamic> inferenceResults = await inference(isolateData);

        var uiThreadInferenceElapsedTime = DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;

        widget.resultsCallback(inferenceResults["recognitions"]);
        widget.statsCallback((inferenceResults["stats"] as Stats)..totalElapsedTime = uiThreadInferenceElapsedTime);

        if (mounted) {
          setState(() {
            predicting = false;
          });
        }
      }
    }
  }

  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolateUtils.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  void startCamera() {
    Future.delayed(Duration(seconds: 1), () async {
      try {
        await cameraController!.startImageStream(onLatestImageAvailable);
      } catch (e) {
        startCamera();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController!.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController!.value.isStreamingImages) {
          startCamera();
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (cameraController != null) {
      cameraController!.dispose();
    }
    super.dispose();
  }
}
