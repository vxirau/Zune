//FLUTTER NATIVE
import 'package:flutter/material.dart';

//MODELS
import 'package:zune/src/models/utilities/hex_color.dart';

//PAQUETS INSTALATS
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  String text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  TextAlign? textAlign;
  int? maxLines;
  double? letterSpacing;
  bool? underline;
  Color? underlineColor;
  double? underlineThickness;
  double? minFont;
  TextOverflow? overflow;
  FontStyle? fontStyle;

  CustomText(this.text, {Key? key, this.color, this.fontSize, this.fontWeight, this.textAlign, this.maxLines, this.minFont, this.underlineThickness, this.underlineColor, this.overflow, this.fontStyle, this.letterSpacing, this.underline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.maxLines == null
        ? Text(this.text,
            textAlign: this.textAlign == null ? TextAlign.start : this.textAlign,
            overflow: this.overflow == null ? null : this.overflow,
            softWrap: this.overflow != TextOverflow.fade,
            style: GoogleFonts.roboto(
              fontStyle: this.fontStyle,
              textStyle: TextStyle(
                  fontSize: this.fontSize == null ? 15 : this.fontSize,
                  color: this.color == null ? HexColor.fromHex("#303030") : this.color,
                  letterSpacing: this.letterSpacing == null ? .5 : this.letterSpacing,
                  fontWeight: this.fontWeight == null ? FontWeight.normal : this.fontWeight,
                  decorationColor: this.underline != null && this.underlineColor != null ? this.underlineColor : null,
                  decorationThickness: this.underline != null && this.underlineThickness != null ? this.underlineThickness : null,
                  decoration: this.underline == null ? TextDecoration.none : (this.underline! ? TextDecoration.underline : TextDecoration.none)),
            ))
        : AutoSizeText(this.text,
            textAlign: this.textAlign == null ? TextAlign.start : this.textAlign,
            overflow: this.overflow == null ? null : this.overflow,
            minFontSize: this.minFont == null ? 10 : this.minFont!,
            style: GoogleFonts.roboto(
                fontStyle: this.fontStyle,
                textStyle: TextStyle(
                    fontSize: this.fontSize == null ? 15 : this.fontSize,
                    color: this.color == null ? HexColor.fromHex("#303030") : this.color,
                    letterSpacing: this.letterSpacing == null ? .5 : this.letterSpacing,
                    fontWeight: this.fontWeight == null ? FontWeight.normal : this.fontWeight,
                    decoration: this.underline == null ? TextDecoration.none : (this.underline! ? TextDecoration.underline : TextDecoration.none))),
            maxLines: this.maxLines);
  }
}
