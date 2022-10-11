//FLUTTER NATIVE
import 'package:flutter/services.dart';

//MODELS
import 'package:zune/src/models/utilities/hex_color.dart';

class AppColors {
  //APP COLORS
  static const String mainTeal = "#FFA400";
  static const String darkContrast = "#393B37";

  //APP STATUS BAR THEMES
  static final systemTheme = SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: HexColor.fromHex('#373A36'),
    systemNavigationBarIconBrightness: Brightness.light,
  );
}
