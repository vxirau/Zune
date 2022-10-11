//FLUTTER NATIVE
import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  double? height;
  double? width;
  double? spreadRadius;
  double? opacity;
  double? blurRadius;
  Offset? offset;
  Color? backgroundColor;
  Color? borderColor;
  Widget child;
  bool? wantsShadow;
  EdgeInsets? padding;

  CircularIcon({required this.child, this.wantsShadow, this.borderColor, this.height, this.width, this.padding, this.backgroundColor, this.blurRadius, this.offset, this.opacity, this.spreadRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.height == null ? 55 : this.height,
      height: this.width == null ? 55 : this.width,
      padding: this.padding == null ? null : this.padding,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: this.backgroundColor == null ? Colors.black : this.backgroundColor,
          boxShadow: wantsShadow != null && wantsShadow!
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(this.opacity == null ? 1 : this.opacity!),
                    spreadRadius: this.spreadRadius == null ? -3 : this.spreadRadius!,
                    blurRadius: this.blurRadius == null ? 11 : this.blurRadius!,
                    offset: this.offset == null ? const Offset(0, 1) : this.offset!,
                  ),
                ]
              : null,
          border: borderColor != null ? Border.all(color: borderColor!, width: 2) : null),
      child: Center(child: this.child),
    );
  }
}
