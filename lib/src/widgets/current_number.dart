import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentNumber extends StatefulWidget {
  Function onChange;
  Function onReset;

  CurrentNumber({required this.onChange, required this.onReset});

  @override
  _CurrentNumberState createState() => _CurrentNumberState();
}

class _CurrentNumberState extends State<CurrentNumber> {
  int _liveUsers = -1;

  late StreamSubscription _remoteStream;
  late StreamSubscription _remoteMaxNumberStream;
  final _database = FirebaseDatabase.instance;

  String _initialNumber = "";
  String _requiredNextNumber = "";

  String _maxNumber = "";
  String _nextMaxNumber = "";

  @override
  void initState() {
    super.initState();

    _remoteStream = _database.ref("maxCount/number").onValue.listen((event) {
      Object? remoteDB = event.snapshot.value;
      _initialNumber = remoteDB as String;
      List<String> list = _initialNumber.split("");
      calculateNextString(list, list.length - 1);
      _requiredNextNumber = list.join("");
      widget.onChange(
          _initialNumber, _requiredNextNumber, _maxNumber, _nextMaxNumber);
      setState(() {});
      Future.microtask(() {
        if (_initialNumber == "0") {
          widget.onReset();
        }
      });
    });

    _remoteMaxNumberStream =
        _database.ref("maxCount/maxNumber").onValue.listen((event) {
      Object? remoteDB = event.snapshot.value;
      _maxNumber = remoteDB as String;
      List<String> list = _maxNumber.split("");
      calculateNextString(list, list.length - 1);
      _nextMaxNumber = list.join("");
      setState(() {});
    });
  }

  @override
  void dispose() {
    _remoteStream.cancel();
    _remoteMaxNumberStream.cancel();
    super.dispose();
  }

  void calculateNextString(List<String> list, int index) {
    if (index == -1) {
      list.insert(0, "1");
      return;
    } else {
      if (list[index] == '9') {
        list[index] = '0';
        index--;
        calculateNextString(list, index);
      } else {
        list[index] = (double.parse(list[index]) + 1).toStringAsFixed(0);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            _initialNumber.isEmpty ? "--" : _initialNumber,
            style: GoogleFonts.vt323(
                textStyle: TextStyle(
                    fontSize: shortestSide < 600 ? 60 : 70,
                    fontWeight: FontWeight.bold)),
            maxLines: 1,
          ),
          AutoSizeText(
            _maxNumber.isEmpty ? "Max Reached: --" : "Max Reached: $_maxNumber",
            style: GoogleFonts.vt323(
                textStyle: TextStyle(
                    fontSize: shortestSide < 600 ? 17 : 30,
                    fontWeight: FontWeight.bold)),
            maxLines: 1,
          )
        ],
      ),
    );
  }
}
