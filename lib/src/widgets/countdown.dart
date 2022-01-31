import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CountDown extends StatefulWidget {
  Function callback;

  ValueListenable<int> number;

  CountDown({required this.number, required this.callback});

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  late Timer _timer;
  int numTimer = 12;
  bool isCounting = false;
  int _maxPeticions = -1;

  final _database = FirebaseDatabase.instance;
  late StreamSubscription _maxPeticionsStream;

  @override
  void initState() {
    _maxPeticionsStream =
        _database.ref("maxCount/maxPeticions").onValue.listen((event) {
      Object? value = event.snapshot.value;
      value ??= 10;
      setState(() {
        _maxPeticions = value as int;
        if (widget.number.value < 0) {
          widget.callback(_maxPeticions);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (isCounting) {
      _timer.cancel();
    }
    _maxPeticionsStream.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return ValueListenableBuilder<int>(
      builder: (BuildContext context, int value, Widget? child) {
        if (isCounting == false) {
          if (widget.number.value < _maxPeticions) {
            isCounting = true;
            numTimer = 0;
            _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
              if (numTimer == 11) {
                widget.callback(_maxPeticions);
                numTimer = 15;
                timer.cancel();
                isCounting = false;
              }
              numTimer++;
              setState(() {});
            });
          }
        }

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
                child: Text(_maxPeticions > 0 ? "${widget.number.value}" : "-",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vt323(
                        textStyle: TextStyle(
                            fontSize: shortestSide < 600 ? 15 : 24,
                            fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        );
      },
      valueListenable: widget.number,
    );
  }
}
