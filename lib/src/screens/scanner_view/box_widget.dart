//FLUTTER NATIVE
import 'dart:math';

import 'package:flutter/material.dart';

//MODELS
import 'package:zune/src/models/tflite/recognition.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/models/utilities/toast_utility.dart';
import 'package:zune/src/models/utilities/types.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';

//PACKAGES INSTALATS
import 'package:url_launcher/url_launcher.dart';

class BoxWidget extends StatelessWidget {
  Recognition result;

  BoxWidget({Key? key, required this.result}) : super(key: key);

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: result.renderLocation.left + (result.renderLocation.width / 2),
      top: result.renderLocation.top + (result.renderLocation.height / 2),
      child: GestureDetector(
        onTap: () {
          if (result.action != null) {
            if (result.type == 1) {
              _launchURL(result.action!);
            } else if (result.type == 0) {
              ToastUtility.standardToast(result.action!);
            }
          } else {
            ToastUtility.standardToast("NO ACTION ASSIGNED");
          }
        },
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(shape: BoxShape.circle, color: result.isSaved != null && result.isSaved! ? HexColor.fromHex("#DBFBB5").withAlpha(40) : HexColor.fromHex("#8A66E6").withAlpha(40)),
              child: Center(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: result.isSaved != null && result.isSaved! ? HexColor.fromHex("#DBFBB5") : HexColor.fromHex("#8A66E6")),
                  child: result.isSaved != null && result.isSaved!
                      ? (result.type == 1
                          ? Transform.rotate(
                              angle: 135 * pi / 180,
                              child: Icon(
                                Types.icons[result.type]!.data,
                                color: HexColor.fromHex("#343334"),
                                size: 17,
                              ),
                            )
                          : Icon(
                              Types.icons[result.type]!.data,
                              color: HexColor.fromHex("#343334"),
                              size: 17,
                            ))
                      : null,
                ),
              ),
            ),
            CustomText(
              "${result.label}-${result.score.toStringAsFixed(2)}",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )
          ],
        ),
      ),
    );
  }
}

bool isSaved() {
  return false;
}
