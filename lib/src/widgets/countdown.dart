import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CountDown extends StatefulWidget {
  int maxPeticions;
  int numPeticions;
  Function callback;

  CountDown(
      {required this.maxPeticions,
      required this.numPeticions,
      required this.callback});

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  late Timer _timer;
  int numTimer = 12;
  bool isCounting = false;

  @override
  void dispose() {
    if (isCounting) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isCounting == false) {
      if (widget.numPeticions < widget.maxPeticions) {
        isCounting = true;
        numTimer = 0;
        _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
          if (numTimer == 11) {
            widget.callback();
            numTimer = 15;
            timer.cancel();
            isCounting = false;
          }
          numTimer++;
          setState(() {});
        });
      }
    }

    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: shortestSide < 600 ? 25 : 40,
          width: shortestSide < 600 ? 25 : 40,
          child: CircularProgressIndicator(
            value: numTimer / 12,
            semanticsValue: "1",
            strokeWidth: shortestSide < 600 ? 4 : 5,
            color: Colors.red,
            backgroundColor: Colors.black,
          ),
        ),
        Positioned.fill(
          top: shortestSide < 600 ? 3 : 6,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
                widget.maxPeticions > 0 ? "${widget.numPeticions}" : "-",
                textAlign: TextAlign.center,
                style: GoogleFonts.vt323(
                    textStyle: TextStyle(
                        fontSize: shortestSide < 600 ? 15 : 24,
                        fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }
}
