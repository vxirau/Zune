// ignore_for_file: public_member_api_docs, sort_constructors_first
//FLUTTER NATIVE
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:zune/src/models/models.dart';

//MODELS
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/screens/scanner_view/box_widget.dart';
import 'package:zune/src/screens/scanner_view/camera_view.dart';

//WIDGETS
import 'package:zune/src/widgets/widgets.dart';

//PAQUETS INSTALATS
import 'package:provider/provider.dart';
import 'package:zune/src/providers/ui_provider.dart';

class ARView extends StatefulWidget {
  Function callback;
  ARView({
    required this.callback,
  });
  @override
  State<ARView> createState() => _ARViewState();

}

class _ARViewState extends State<ARView> with SingleTickerProviderStateMixin {
  bool isColored = false;
  bool pendingAnimation = true;

  bool hasAccepted = false;

  bool _pressed = false;

  double minSize = 0.0;

  DraggableScrollableController _dragController = DraggableScrollableController();

  Animation<double>? closedAnimation;
  late AnimationController controller;
  double maxSize = 0.01;

  List<Recognition> results = [];
  List<Recognition> dialog = [];

  Stats? stats;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UiProvider uiProvider = Provider.of<UiProvider>(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (closedAnimation == null) {
      closedAnimation = Tween<double>(begin: 130, end: height - 150).animate(controller)
        ..addListener(() {
          setState(() {});
        });
    }

    /*
    
    130 --> 0.0
    height - 150 --> 0.9

    (150-130)/(0.9-0.0) = 20
    
    */

    if (pendingAnimation) {
      Future.microtask(() async {
        await Future.delayed(Duration(milliseconds: 500));
        isColored = true;
        if (mounted) {
          setState(() {});
        }
      });
      pendingAnimation = false;
    }

    return Hero(
      tag: "center-animation",
      child: Scaffold(
        backgroundColor: HexColor.fromHex("#DBFBB5"),
        body: AnimatedOpacity(
          duration: Duration(milliseconds: 250),
          opacity: isColored ? 1 : 0,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(_pressed ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0), BlendMode.darken),
                      child: Stack(
                        children: [
                          Center(child: CameraView(resultsCallback, statsCallback)),
                          boundingBoxes(results),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 10),
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 45,
                          onPressed: () {
                            uiProvider.isFabVisible = true;
                            Navigator.pop(context);
                          },
                          icon: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.keyboard_arrow_left_rounded,
                                color: Colors.black,
                                size: 50,
                              ),
                            ),
                          )),
                    ),
                  ),
                  DraggableScrollableSheet(
                    controller: _dragController,
                    initialChildSize: (closedAnimation!.value - 130) < 0 ? 0.0 : (closedAnimation!.value - 130) / ((height - 150 - 130) / 0.9),
                    minChildSize: (closedAnimation!.value - 130) < 0 ? 0.0 : (closedAnimation!.value - 130) / ((height - 150 - 130) / 0.9),
                    maxChildSize: maxSize,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                          height: height * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: const Radius.circular(20.0), topLeft: Radius.circular(20.0)),
                            color: HexColor.fromHex("#292828"),
                            boxShadow: [
                              const BoxShadow(color: Colors.black54, spreadRadius: 1, blurRadius: 1),
                            ],
                          ),
                          child: ListView(controller: scrollController, physics: BouncingScrollPhysics(), children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, top: 35),
                              child: CustomText(
                                "Detected Objects",
                                fontWeight: FontWeight.bold,
                                color: HexColor.fromHex("#DBFBB5"),
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20),
                              child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  children: _generateGridChildren(dialog)),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ]));
                    },
                  ),
                  _pressed
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 160,
                            width: 70,
                            margin: EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  hasAccepted
                      ? (Positioned(
                          left: 0,
                          right: 0,
                          bottom: closedAnimation!.value < 0 ? 0 : closedAnimation!.value,
                          child: GestureDetector(
                            onTap: closedAnimation!.value == height - 150
                                ? () async {
                                    closedAnimation = Tween<double>(begin: 30, end: height - 150).animate(controller)
                                      ..addListener(() {
                                        setState(() {});
                                      });
                                    _dragController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                                    setState(() {});
                                    await controller.reverse();

                                    hasAccepted = false;
                                    _pressed = false;
                                    setState(() {});
                                  }
                                : null,
                            child: CircularIcon(
                              spreadRadius: 1,
                              wantsShadow: !hasAccepted,
                              blurRadius: 2,
                              backgroundColor: HexColor.fromHex("#292828"),
                              height: 70,
                              width: 70,
                              child: Transform.rotate(
                                angle: pi,
                                child: Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: Colors.white,
                                  size: 55,
                                ),
                              ),
                            ),
                          ),
                        ))
                      : DraggableConfirmationSlider(onStarted: () {
                          _pressed = true;
                          setState(() {});
                        }, onEnded: (isSuccessful) async {
                          hasAccepted = isSuccessful;
                          if (isSuccessful) {
                            maxSize = 0.9;
                            dialog = results;
                            widget.callback(dialog);
                            setState(() {});
                            controller.forward();
                          }
                          _pressed = false;
                          setState(() {});
                        }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget boundingBoxes(List<Recognition> results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
              ))
          .toList(),
    );
  }

  // Future<void> funcion() async{
  //   for(){

  //     }

  // }

  void resultsCallback(List<Recognition> results) {
    if (mounted) {
      //funcion();
      setState(() {
        this.results = results;
      });
    }
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    if (mounted) {
      setState(() {
        this.stats = stats;
      });
    }
  }

  List<Widget> _generateGridChildren(List<Recognition> dialog) {
    return dialog
        .map((e) => GridCard(e.id, e.label, onClick: (ind) {
              print("Detected: $ind");
            }))
        .toList();
  }
}
