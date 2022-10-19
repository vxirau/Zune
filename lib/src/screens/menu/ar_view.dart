import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/providers/ui_provider.dart';
import 'package:zune/src/widgets/cards/circular_icon.dart';
import 'package:zune/src/widgets/sliders/confirmation_slider.dart';
import 'package:zune/src/widgets/text/custom_text.dart';

class ARView extends StatefulWidget {
  @override
  State<ARView> createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  bool isColored = false;
  bool pendingAnimation = true;

  bool hasAccepted = false;

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    UiProvider uiProvider = Provider.of<UiProvider>(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                      child: Container(
                        height: height,
                        width: width,
                        color: Colors.blue.shade100,
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
                  _pressed
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 160,
                            width: 60,
                            margin: EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  hasAccepted
                      ? Positioned(
                          left: 0,
                          right: 0,
                          bottom: 130,
                          child: CircularIcon(
                            spreadRadius: 1,
                            wantsShadow: true,
                            blurRadius: 2,
                            backgroundColor: Colors.black87,
                            child: Transform.rotate(
                              angle: pi,
                              child: Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        )
                      : DraggableConfirmationSlider(onStarted: () {
                          _pressed = true;
                          setState(() {});
                        }, onEnded: (isSuccessful) {
                          hasAccepted = isSuccessful;
                          _pressed = false;
                          setState(() {});
                        })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
