import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:object_detection/ui/home_view.dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Dyvide', initialRoute: '/', routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => HomeView(),
      }),
    );
  }
}



















/*
rm -Rf build
rm -Rf .dart_tool
rm .packages
rm -Rf ios/Pods
rm -Rf ios/.symlinks      
rm -Rf ios/Flutter/Flutter.framework
rm -Rf ios/Flutter/Flutter.podspec  
rm -Rf /Users/victorxirauguardans/Library/Developer/Xcode/DerivedData
pod cache clean --all  
cd ios
pod deintegrate
pod setup
arch -x86_64 pod install         
cd ..
flutter clean -v
flutter pub get
flutter build ipa

*/
