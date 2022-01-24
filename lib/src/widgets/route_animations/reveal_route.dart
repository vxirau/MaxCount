//FLUTTER NATIVE
import 'package:flutter/material.dart';


import 'circular_reveal_clipper.dart';

class RevealRoute extends PageRouteBuilder {
  Widget page;
  Alignment centerAlignment;
  Offset centerOffset;
  double minRadius;
  double maxRadius;

  RevealRoute({
    required this.page,
    this.minRadius = 0,
    required this.maxRadius,
    required this.centerAlignment,
    required this.centerOffset,
  }) : super(

          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,

          ) => page, transitionDuration: Duration(seconds: 1)
          );


  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  
  ) {
    return ClipPath(
      clipper: CircularRevealClipper(
        fraction: animation.value,
        centerAlignment: centerAlignment,
        centerOffset: centerOffset,
        minRadius: minRadius,
        maxRadius: maxRadius,
      ),
      child: child,
    
    );
  }
}