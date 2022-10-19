import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/widgets/cards/circular_icon.dart';

class DraggableConfirmationSlider extends StatefulWidget {
  Function onStarted;
  Function onEnded;

  DraggableConfirmationSlider({required this.onStarted, required this.onEnded});

  @override
  State<DraggableConfirmationSlider> createState() => _DraggableConfirmationSliderState();
}

class _DraggableConfirmationSliderState extends State<DraggableConfirmationSlider> {
  bool _pressed = false;

  double verticalPos = 30;

  bool needsVibrate = true;

  double angle = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 100),
      bottom: verticalPos,
      left: 0,
      right: 0,
      child: GestureDetector(
          onTapDown: (_) {
            dragStarted();
          },
          onTapUp: (_) {
            dragEnded();
          },
          onVerticalDragEnd: (_) {
            dragEnded();
          },
          onVerticalDragStart: (_) {
            dragStarted();
          },
          onVerticalDragUpdate: (DragUpdateDetails? details) {
            if (details != null) {
              if (verticalPos < 130 && (verticalPos - details.primaryDelta!) < 130 && verticalPos >= 30 && (verticalPos - details.primaryDelta!) >= 30) {
                verticalPos = verticalPos - details.primaryDelta!;
                angle = ((verticalPos - 30) * (180 / 100)) * (pi / 180);
                setState(() {});
              }

              if (verticalPos > 125) {
                if (needsVibrate) {
                  HapticFeedback.vibrate();
                  needsVibrate = false;
                }
              } else {
                needsVibrate = true;
              }
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: CircularIcon(
              spreadRadius: 1,
              wantsShadow: true,
              blurRadius: 2,
              height: 70,
              width: 70,
              backgroundColor: _pressed ? HexColor.fromHex("#292828") : Colors.red.shade600,
              child: Transform.rotate(
                angle: angle,
                child: Icon(
                  _pressed ? Icons.keyboard_arrow_up_rounded : Icons.close,
                  color: Colors.white,
                  size: _pressed ? 55 : 35,
                ),
              ),
            ),
          )),
    );
  }

  void dragEnded() {
    if (verticalPos > 120) {
      print("ACCEPTED");
      widget.onEnded(true);
    } else {
      verticalPos = 30;
      angle = 0;
      widget.onEnded(false);
    }
    _pressed = false;
    setState(() {});
  }

  void dragStarted() {
    _pressed = true;
    widget.onStarted();
    setState(() {});
  }
}
