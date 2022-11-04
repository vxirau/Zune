//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/widgets/widgets.dart';
import 'dart:math' as math;


class CustomIcon extends StatelessWidget {
  bool isText;

  CustomIcon({required this.isText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [    
          Column(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: HexColor.fromHex("#343334"),
                borderRadius: BorderRadius.all(Radius.circular(12))),
              child: isText ? Icon(Icons.text_fields, color: HexColor.fromHex("#DBFBB5"),) : Transform.rotate(angle: 135 * math.pi / 180, child:Icon((Icons.link), color: HexColor.fromHex("#DBFBB5"))),
            ),
            SizedBox(height: 5),
            CustomText(isText ? "Text" : "Link")   
          ],)
        ],
      ),
    );
  }
}
