//FLUTTER NATIVE
import 'package:flutter/material.dart';

class ShadowCard extends StatefulWidget {
  double height;
  double width;
  Widget child;
  double opacity = 0.25;
  Function? action;
  Color? color;
  double? radius;
  double? spreadRadius;
  double? blurRadius;
  Offset? offset;
  bool? padding;
  EdgeInsets? margin;
  bool? wantsShadow;

  ShadowCard({required this.height, this.wantsShadow, required this.width, required this.child, this.action, this.color, this.padding, this.blurRadius, this.offset, this.margin, this.radius, this.spreadRadius});

  @override
  _ShadowCardState createState() => _ShadowCardState();
}

class _ShadowCardState extends State<ShadowCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) {
        if (widget.action != null) {
          widget.opacity = 0.15;
          setState(() {});
        }
      },
      onTapUp: (_) {
        if (widget.action != null) {
          widget.opacity = 0.25;
          setState(() {});
        }
      },
      onTap: () {
        if (widget.action != null) {
          widget.action!();
        }
      },
      child: Container(
        margin: widget.margin == null ? null : widget.margin,
        height: widget.height,
        width: widget.width,
        padding: widget.padding == null ? const EdgeInsets.all(10.0) : (widget.padding! ? const EdgeInsets.all(10.0) : null),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius == null ? 10 : widget.radius!),
          color: widget.color == null ? Colors.white : widget.color,
          boxShadow: widget.wantsShadow == null || widget.wantsShadow == true
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(widget.opacity),
                    spreadRadius: widget.spreadRadius == null ? 4 : widget.spreadRadius!,
                    blurRadius: widget.blurRadius == null ? 18 : widget.blurRadius!,
                    offset: widget.offset == null ? const Offset(0, 1) : widget.offset!, // changes position of shadow
                  ),
                ]
              : null,
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
