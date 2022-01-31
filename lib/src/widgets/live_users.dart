import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveUsers extends StatefulWidget {
  @override
  _LiveUsersState createState() => _LiveUsersState();
}

class _LiveUsersState extends State<LiveUsers> {
  int _liveUsers = -1;

  late StreamSubscription _remoteStream;
  final _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();

    _remoteStream = _database.ref("maxCount/liveUsers").onValue.listen((event) {
      Object? remoteDB = event.snapshot.value;
      _liveUsers = remoteDB as int;
      setState(() {});
      Future.microtask(() {
        if (_liveUsers < 0) {
          _database.ref("maxCount/").update({
            "liveUsers": 0,
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _remoteStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return AutoSizeText(
      _liveUsers < 0 ? "Live Users: -" : "Live Users: $_liveUsers",
      style: GoogleFonts.vt323(
          textStyle: TextStyle(
              fontSize: shortestSide < 600 ? 20 : 30,
              fontWeight: FontWeight.bold)),
      maxLines: 1,
    );
  }
}
