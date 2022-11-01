//FLUTTER NATIVE
import 'package:flutter/material.dart';

//MODELS
import 'package:zune/src/models/tflite/recognition.dart';
import 'package:zune/src/models/utilities/hex_color.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';

/// Individual bounding box
class BoxWidget extends StatelessWidget {
  Recognition result;

  BoxWidget({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Color for bounding box
    Color color = Colors.primaries[(result.label.length + result.label.codeUnitAt(0) + result.id) % Colors.primaries.length];

    return Positioned(
      left: result.renderLocation.left + (result.renderLocation.width / 2),
      top: result.renderLocation.top + (result.renderLocation.height / 2),
      child: GestureDetector(
        onTap: () {
          print(result.label);
        },
        child: Column(
          children: [
            Container(
              width: 60, //result.renderLocation.width,
              height: 60, //result.renderLocation.height,
              decoration: BoxDecoration(shape: BoxShape.circle, color: HexColor.fromHex("#DBFBB5").withAlpha(40)),
              child: Center(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: HexColor.fromHex("#DBFBB5")),
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
