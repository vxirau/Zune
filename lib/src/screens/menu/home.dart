//FLUTTER NATIVE
import 'package:flutter/material.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CustomText(
          "Home",
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
