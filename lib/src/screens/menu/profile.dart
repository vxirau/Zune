//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'package:zune/src/widgets/dialog/object_dialog.dart';
import 'package:zune/src/models/object/obj.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';


import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';


class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: /*CustomText( //Este custom text pasa a ser mi dialog personalizado (llamar showDialog(aqui pasamos el dialog personalizado))
          "Profile",
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),*/
          ElevatedButton(
            child: Text('Clickk'),
            onPressed: () => showAnimatedDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return ObjectDialog(
                             obj: Obj(title: "Hola", isText: false, content: "hhhhh")
                          );
                  },
                  animationType: DialogTransitionType.fadeScale,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 500),
                )
          )
        //ObjectDialog(obj: Obj(title: "Hola", isText: false, content: "hhhhh")),
      ),
    );
  }
}
