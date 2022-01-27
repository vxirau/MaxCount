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
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.black, width: 3),
        shape: BoxShape.circle,
      ),
      height: shortestSide < 600 ? 60.0 : 80,
      width: shortestSide < 600 ? 60.0 : 80,
      child: ClipOval(
        child: Material(
          color: this.color,
          child: InkWell(
              splashColor: this.splashColor,
              onTap: () {
                onTap();
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: this.children)),
        ),
      ),
    );
  }
}
