import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class Lives extends StatefulWidget {
  Function callback;

  Lives({required this.callback});

  @override
  _LivesState createState() => _LivesState();
}

class _LivesState extends State<Lives> {
  late StreamSubscription _remoteStream;
  late StreamSubscription _regenerateStream;
  final _database = FirebaseDatabase.instance;
  int _numLives = -1;
  int _regenerate = -1;

  @override
  void initState() {
    super.initState();

    _remoteStream = _database.ref("maxCount/lives").onValue.listen((event) {
      Object? remoteDB = event.snapshot.value;
      _numLives = remoteDB as int;
      if (_numLives == 4) {
        _database.ref("maxCount/").update({"lives": 3});
      }
      widget.callback(_numLives);
      setState(() {});
    });

    _regenerateStream =
        _database.ref("maxCount/lifeReset").onValue.listen((event) {
      Object? remoteDB = event.snapshot.value;
      _regenerate = remoteDB as int;
      if (_regenerate == 0 && _numLives < 3 && _regenerate != 50) {
        if (_numLives == 2) {
          _database.ref("maxCount/").update({"lives": 3, "lifeReset": 50});
        } else {
          _database
              .ref("maxCount/")
              .update({"lives": ServerValue.increment(1), "lifeReset": 50});
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _remoteStream.cancel();
    _regenerateStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Column(
      children: [
        AutoSizeText(
          "Remaining Lives",
          style: GoogleFonts.vt323(
              textStyle: TextStyle(
                  fontSize: shortestSide < 600 ? 25 : 35,
                  fontWeight: FontWeight.bold)),
          maxLines: 1,
        ),
        SizedBox(
          height: 5,
        ),
        _numLives >= 0 && _numLives < 3
            ? AutoSizeText(
                _regenerate == -1
                    ? "Guess -- more correctly to regenerate "
                    : "Guess $_regenerate more correctly to regenerate",
                style: GoogleFonts.vt323(
                    textStyle: TextStyle(
                        fontSize: shortestSide < 600 ? 17 : 24,
                        fontWeight: FontWeight.normal)),
                maxLines: 1,
              )
            : AutoSizeText(
                "Guess -- more correctly to regenerate ",
                style: GoogleFonts.vt323(
                    textStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.transparent,
                        fontWeight: FontWeight.bold)),
                maxLines: 1,
              ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _generateLives(shortestSide),
        ),
      ],
    );
  }

  List<Widget> _generateLives(shortestSide) {
    List<Widget> hearts = [];
    if (_numLives >= 0) {
      for (var i = 0; i < _numLives && i < 3; i++) {
        hearts.add(Container(
          height: shortestSide < 600 ? 50 : 70,
          width: shortestSide < 600 ? 50 : 70,
          child: Image.asset(
            'assets/heart.png',
            fit: BoxFit.contain,
          ),
        ));
      }
      for (var i = _numLives; i < 3; i++) {
        hearts.add(Container(
          height: shortestSide < 600 ? 50 : 70,
          width: shortestSide < 600 ? 50 : 70,
          child: Image.asset(
            'assets/heart_gone.png',
            fit: BoxFit.contain,
          ),
        ));
      }
    } else {
      for (var i = 0; i < 3; i++) {
        hearts.add(Container(
          height: shortestSide < 600 ? 50 : 70,
          width: shortestSide < 600 ? 50 : 70,
          child: Image.asset(
            'assets/heart_gone.png',
            fit: BoxFit.contain,
          ),
        ));
      }
    }

    return hearts;
  }
}
