//FLUTTER NATIVE
import 'dart:async';
import 'package:flutter/material.dart';

//SCREENS
import 'package:zune/src/screens/main_body.dart';

//WIDGETS
import 'package:zune/src/widgets/text/custom_text.dart';

class SplashScreen extends StatefulWidget {
  static bool hasLoaded = false;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool dialegEnsenyat = false;
  bool estaFentFuture = false;

  @override
  Widget build(BuildContext context) {
    if (SplashScreen.hasLoaded) {
      return MainBody();
    }

    return FutureBuilder(
        future: _gestionaAsync(context),
        builder: (c, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Container(
              child: Center(child: CustomText("Error")),
            );
          } else if (asyncSnapshot.hasData) {
            SplashScreen.hasLoaded = true;
            return MainBody();
          }

          return Material(
            child: Container(
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Loading Screen :)",
                    color: Colors.white,
                    fontSize: 30,
                  )
                ],
              ),
            ),
          );
        });
  }

  Future waitWhile(bool test(), [Duration pollInterval = Duration.zero]) {
    var completer = Completer();
    check() {
      if (!test()) {
        completer.complete();
      } else {
        Timer(pollInterval, check);
      }
    }

    check();
    return completer.future;
  }

  Future _gestionaAsync(context) async {
    await Future.delayed(Duration(seconds: 1));
    return 1;
  }
}
