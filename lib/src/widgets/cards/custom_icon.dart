//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/models/utilities/types.dart';
import 'package:zune/src/widgets/cards/shadow_card.dart';
import 'package:zune/src/widgets/widgets.dart';
import 'dart:math' as math;

class CustomIcon extends StatelessWidget {
  int type;
  int selected;
  bool isHome;
  Function callback;

  CustomIcon({required this.type, required this.isHome, required this.callback, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 15, top: 15),
            child: ShadowCard(
              height: 50,
              width: 50,
              color: type != selected ? HexColor.fromHex("#343334") : HexColor.fromHex("#DBFBB5"),
              wantsShadow: type == selected,
              action: () {
                callback(type);
              },
              child: type == 1
                  ? Transform.rotate(
                      angle: 135 * math.pi / 180,
                      child: Icon(
                        Types.icons[type]!.data,
                        color: type != selected ? HexColor.fromHex("#DBFBB5") : HexColor.fromHex("#343334"),
                        size: 25,
                      ),
                    )
                  : Icon(
                      Types.icons[type]!.data,
                      color: type != selected ? HexColor.fromHex("#DBFBB5") : HexColor.fromHex("#343334"),
                      size: 25,
                    ),
            )),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 5),
          child: CustomText(
            Types.icons[type]!.text,
            color: isHome ? HexColor.fromHex("#DBFBB5") : HexColor.fromHex("#343334"),
            fontSize: 12,
          ),
        )
      ],
    ));
  }
}

//Transform.rotate(angle: 135 * math.pi / 180, child:Icon((Icons.link), color: HexColor.fromHex("#DBFBB5"))),
