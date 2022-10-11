//FLUTTER NATIVE
import 'package:flutter/material.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CustomText(
          "Profile",
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
