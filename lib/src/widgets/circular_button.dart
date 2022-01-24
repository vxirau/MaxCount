//FLUTTER NATIVE
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularButton extends StatelessWidget {
  List<Widget> children;
  Function onTap;
  Color splashColor;
  Color color;

  CircularButton(
      {required this.children,
      required this.onTap,
      required this.splashColor,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.black, width: 3),
        shape: BoxShape.circle,
      ),
      height: 60.0,
      width: 60.0, // button width and height
      child: ClipOval(
        child: Material(
          color: this.color, // button color
          child: InkWell(
              splashColor: this.splashColor, // splash color
              onTap: () {
                onTap();
              }, // button pressed
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: this.children)),
        ),
      ),
    );
  }
}
