import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zune/src/providers/ui_provider.dart';
import 'package:zune/src/screens/menu/splash_screen.dart';
import 'package:zune/src/screens/scanner_view/scanner_view.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UiProvider()),
        ],
        child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Zune', initialRoute: '/', routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => SplashScreen(),
        }),
      ),
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
