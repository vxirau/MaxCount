// ignore_for_file: prefer_const_constructors

import 'dart:async';
import "dart:math";
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:max_count/src/models/hex_color.dart';
import 'package:max_count/src/screens/screens.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:just_audio/just_audio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  String _initialNumber = "";
  int _numLives = 3;
  int _liveUsers = -1;
  final _database = FirebaseDatabase.instance;
  late StreamSubscription _numberStream;
  late StreamSubscription _liveStream;
  late StreamSubscription _liveUsersStream;

  late Timer t;
  bool isCoolingDown = false;

  final _inputController = TextEditingController();
  late AudioPlayer player;

  bool wantsAudio = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    player = AudioPlayer();

    _activateListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _database.ref("maxCount/liveUsers").once().then((event) {
        _liveUsers = int.parse(event.snapshot.value.toString());
        _liveUsers--;
        _database
            .ref("maxCount/")
            .update({"liveUsers": _liveUsers})
            .then((value) {})
            .catchError((error) =>
                _displayToastError("Error", "We encountered a network error"));
      });
    } else if (state == AppLifecycleState.resumed) {
      _database.ref("maxCount/liveUsers").once().then((event) {
        _liveUsers = int.parse(event.snapshot.value.toString());
        _liveUsers++;
        _database
            .ref("maxCount/")
            .update({"liveUsers": _liveUsers})
            .then((value) {})
            .catchError((error) =>
                _displayToastError("Error", "We encountered a network error"));
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  void _activateListeners() {
    _numberStream = _database.ref("maxCount/number").onValue.listen((event) {
      Object newNumber = event.snapshot.value!;
      setState(() {
        if (newNumber == 0) {
          _playReset();
        }
        _initialNumber = newNumber as String;
      });
    });
    _liveStream = _database.ref("maxCount/lives").onValue.listen((event) {
      Object? vides = event.snapshot.value;
      vides ??= 0;
      setState(() {
        _numLives = int.parse(vides.toString());
      });
    });

    _database.ref("maxCount/liveUsers").once().then((event) {
      _liveUsers = int.parse(event.snapshot.value.toString());
      _liveUsers++;
      _database
          .ref("maxCount/")
          .update({"liveUsers": _liveUsers}).then((value) {
        _liveUsersStream =
            _database.ref("maxCount/liveUsers").onValue.listen((event) {
          Object? vides = event.snapshot.value;
          vides ??= 0;
          setState(() {
            _liveUsers = int.parse(vides.toString());
          });
        });
      }).catchError((error) {
        _displayToastError("Error", "We encountered a network error");
        _liveUsersStream =
            _database.ref("maxCount/liveUsers").onValue.listen((event) {
          Object? vides = event.snapshot.value;
          vides ??= 0;
          setState(() {
            _liveUsers = int.parse(vides.toString());
          });
        });
      });
    });
  }

  @override
  void deactivate() {
    _numberStream.cancel();
    _liveStream.cancel();
    _liveUsersStream.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (Provider.of<InternetConnectionStatus>(context) ==
        InternetConnectionStatus.disconnected) {
      return NoInternet();
    }

    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor.fromHex("#5ED466"),
          body: SafeArea(
            child: Container(
              height: height,
              width: width,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText(
                        "Max Count",
                        style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'PixelTitle',
                            color: Colors.black),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.05,
                          ),
                          AutoSizeText(
                            "Live Users: $_liveUsers",
                            style: GoogleFonts.vt323(
                                textStyle: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            maxLines: 1,
                          ),
                          Expanded(child: Container()),
                          IconButton(
                            icon: wantsAudio
                                ? Icon(Icons.volume_up)
                                : Icon(Icons.volume_off_outlined),
                            onPressed: () {
                              setState(() {
                                wantsAudio = !wantsAudio;
                              });
                            },
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      AutoSizeText(
                        "Remaining Lives",
                        style: GoogleFonts.vt323(
                            textStyle: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _generateLives(),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Container(
                        width: width * 0.6,
                        height: width * 0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Center(
                            child: AutoSizeText(
                              _initialNumber,
                              style: GoogleFonts.vt323(
                                  textStyle: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold)),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.07,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.5,
                            height: 50,
                            child: TextField(
                              expands: false,
                              controller: _inputController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter new value',
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.black),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.black),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  filled: true),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _submitAction(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: HexColor.fromHex("#fe0100"),
                                  side: BorderSide(
                                      width: 3.0, color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  )),
                                  minimumSize: Size(30, 50)),
                              child: Icon(Icons.check)),
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ));
  }

  void _submitAction(contexte) async {
    if (Provider.of<InternetConnectionStatus>(contexte, listen: false) ==
        InternetConnectionStatus.connected) {
      if (_inputController.text.isEmpty) {
        _displayToastError(
            "Input Empty", "Please add a number before submiting");
        _playError();
      } else {
        double current = double.parse(_initialNumber);
        double input = double.parse(_inputController.text);
        if (current > input + 10 || current < input - 10) {
          _displayToastError(
              "Not Valid", "Come on... that's obviously not the next number");
          _playError();
        } else {
          current = double.parse(_initialNumber);
          if (current != input - 1) {
            if (isCoolingDown) {
              var list = [
                "You may want to rethink that....",
                "Wait 5 seconds between obvious mistakes...",
                "Don't insist...",
                "Are you trying to fuck up the score?",
                "C'mon... rethink that again!"
              ];
              final _random = Random();
              var element = list[_random.nextInt(list.length)];
              MotionToast(
                icon: Icons.priority_high,
                title: Text(
                  "Error",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                description: Text(element),
                position: MOTION_TOAST_POSITION.top,
                primaryColor: Colors.red,
                enableAnimation: false,
                animationDuration: Duration(milliseconds: 300),
                toastDuration: Duration(seconds: 1),
                animationCurve: Curves.fastOutSlowIn,
                secondaryColor: HexColor.fromHex("#fe0100"),
                animationType: ANIMATION.fromTop,
              ).show(context);
              _playError();
              t.cancel;
            } else {
              _activateCooldown();
              if (_numLives == 1) {
                _playReset();
                _database.ref("maxCount/").update({"lives": 3}).then((value) {
                  _database
                      .ref("maxCount/")
                      .update({"number": "0"})
                      .then((value) {})
                      .catchError((error) => _displayToastError(
                          "Error", "We encountered a network error"));
                }).catchError((error) => _displayToastError(
                    "Error", "We encountered a network error"));
              } else {
                _playErrorNumber();
                _numLives--;
                _database
                    .ref("maxCount/")
                    .update({"lives": _numLives})
                    .then((value) {})
                    .catchError((error) => _displayToastError(
                        "Error", "We encountered a network error"));
              }
            }
          } else {
            _database.ref("maxCount/").update(
                {"number": input.toStringAsFixed(0)}).then((value) {
              _playSuccess();
            }).catchError((error) =>
                _displayToastError("Error", "We encountered a network error"));
          }
        }
        _inputController.clear();
      }
    } else {
      _displayToastError("No Connection", "Please connect to the internet");
      _playError();
    }
  }

  void _playSuccess() async {
    if (wantsAudio) {
      await player.setAsset('assets/sounds/correctAnswer.wav');
      player.play();
    }
  }

  void _playErrorNumber() async {
    if (wantsAudio) {
      await player.setAsset('assets/sounds/mistake.wav');
      player.play();
    }
  }

  void _playError() async {
    if (wantsAudio) {
      await player.setAsset('assets/sounds/quickBip.wav');
      player.play();
    }
  }

  void _playReset() async {
    if (wantsAudio) {
      await player.setAsset('assets/sounds/reset.wav');
      player.play();
    }
  }

  void _activateCooldown() {
    isCoolingDown = true;
    t = Timer(Duration(seconds: 5), () {
      isCoolingDown = false;
    });
  }

  void _displayToastError(String title, String description) {
    MotionToast(
      icon: Icons.priority_high,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      description: Text(description),
      position: MOTION_TOAST_POSITION.top,
      primaryColor: Colors.red,
      enableAnimation: false,
      animationDuration: Duration(milliseconds: 300),
      toastDuration: Duration(seconds: 2),
      animationCurve: Curves.fastOutSlowIn,
      secondaryColor: HexColor.fromHex("#fe0100"),
      animationType: ANIMATION.fromTop,
    ).show(context);
  }

  List<Widget> _generateLives() {
    List<Widget> hearts = [];
    for (var i = 0; i < _numLives; i++) {
      hearts.add(Container(
        height: 50,
        width: 50,
        child: Image.asset(
          'assets/heart.png',
          fit: BoxFit.contain,
        ),
      ));
    }
    for (var i = _numLives; i < 3; i++) {
      hearts.add(Container(
        height: 50,
        width: 50,
        child: Image.asset(
          'assets/heart_gone.png',
          fit: BoxFit.contain,
        ),
      ));
    }
    return hearts;
  }
}
