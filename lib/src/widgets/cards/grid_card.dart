import 'package:flutter/material.dart';
import 'package:zune/src/models/utilities/hex_color.dart';
import 'package:zune/src/widgets/text/custom_text.dart';

class GridCard extends StatelessWidget {
  int index;
  String label;
  Function onClick;

  GridCard(this.index, this.label, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick(index);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(child: CustomText(label, color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 30,
              width: 30,
              margin: const EdgeInsets.only(top: 5, right: 5),
              decoration: BoxDecoration(
                color: HexColor.fromHex("#DBFBB5"),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(child: CustomText("$index", color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
