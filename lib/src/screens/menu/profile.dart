//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'package:zune/src/widgets/dialog/object_dialog.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';

import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

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
