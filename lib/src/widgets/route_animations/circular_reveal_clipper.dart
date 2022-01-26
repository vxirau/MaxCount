//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

class CircularRevealClipper extends CustomClipper<Path> {
  double fraction;
  Alignment centerAlignment;
  Offset centerOffset;
  double minRadius;
  double maxRadius;

  CircularRevealClipper({
    required this.fraction,
    required this.centerAlignment,
    required this.centerOffset,
    required this.minRadius,
    required this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    Offset center = this.centerAlignment.alongSize(size);
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(this.minRadius, this.maxRadius, fraction)!,
        ),

      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}