// ignore_for_file: prefer_const_constructors

//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import "dart:math";
import 'dart:io' show Platform;

//PAQUETS INSTALATS
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//MODELS
import 'package:max_count/src/models/hex_color.dart';

//SCREENS
import 'package:max_count/src/screens/screens.dart';

class Home extends StatefulWidget {
  bool initialSounds;

  Home({required this.initialSounds});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  String _initialNumber = "";
  String _requiredNextNumber = "";
  int _numLives = 0;
  int _liveUsers = -1;
  final _database = FirebaseDatabase.instance;
  late StreamSubscription _numberStream;
  late StreamSubscription _liveStream;
  late StreamSubscription _liveUsersStream;

  late Timer t;
  bool isCoolingDown = false;
  bool needsCooldown = false;

  final _inputController = TextEditingController();
  final AudioPlayer player = AudioPlayer();

  double value = 0;

  late ToastFuture tf;

  int remaining = 10;

  late bool wantsAudio;

  @override
  void initState() {
    super.initState();

    wantsAudio = widget.initialSounds;

    WidgetsBinding.instance!.addObserver(this);

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
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      SharedPreferences.getInstance().then((value) {
        if (value.getBool("isLive") == true) {
          Future.microtask(() {
            _database.ref("maxCount/").update({
              "liveUsers": ServerValue.increment(-1),
            });
            value.setBool("isLive", false);
          });
        }
      });
      player.stop();
    } else if (state == AppLifecycleState.resumed) {
      SharedPreferences.getInstance().then((value) {
        if (value.getBool("isLive") == false) {
          Future.microtask(() {
            _database.ref("maxCount/").update({
              "liveUsers": ServerValue.increment(1),
            });
            value.setBool("isLive", true);
          });
        }
      });
    }
    super.didChangeAppLifecycleState(state);
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

  void _activateListeners() {
    _numberStream = _database.ref("maxCount/number").onValue.listen((event) {
      Object newNumber = event.snapshot.value!;
      setState(() {
        if (newNumber == 0) {
          _playReset();
        }
        _initialNumber = newNumber as String;
        Future.microtask(() {
          List<String> list = _initialNumber.split("");
          calculateNextString(list, list.length - 1);
          _requiredNextNumber = list.join("");
        });
      });
    });
    _liveStream = _database.ref("maxCount/lives").onValue.listen((event) {
      Object? vides = event.snapshot.value;
      vides ??= 0;
      setState(() {
        _numLives = int.parse(vides.toString());
      });
    });

    _liveUsersStream =
        _database.ref("maxCount/liveUsers").onValue.listen((event) {
      Object? vides = event.snapshot.value;
      vides ??= 0;
      setState(() {
        _liveUsers = int.parse(vides.toString());
      });
      Future.microtask(() {
        if (_liveUsers <= 0) {
          _database.ref("maxCount/").update({
            "liveUsers": 1,
          });
        }
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

    final AdManagerBannerAdListener _listener = AdManagerBannerAdListener(
      //onAdLoaded: (Ad ad) => print('Ad loaded.'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
      },
      /*onAdOpened: (Ad ad) => print('Ad opened.'),
      onAdClosed: (Ad ad) => print('Ad closed.'),
      onAdImpression: (Ad ad) => print('Ad impression.'),*/
    );

    final AdManagerBannerAd myBanner;
    if (Platform.isAndroid) {
      myBanner = AdManagerBannerAd(
        adUnitId: 'ca-app-pub-6805626204344763/5143161253',
        sizes: [AdSize(width: width.toInt(), height: (height * 0.1).toInt())],
        request: AdManagerAdRequest(),
        listener: _listener,
      );
    } else {
      myBanner = AdManagerBannerAd(
        adUnitId: 'ca-app-pub-6805626204344763/8322012453',
        sizes: [AdSize(width: width.toInt(), height: (height * 0.1).toInt())],
        request: AdManagerAdRequest(),
        listener: _listener,
      );
    }

    myBanner.load();

    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor.fromHex("#5ED466"),
          body: SafeArea(
            minimum: EdgeInsets.only(top: 16.0, bottom: 20),
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
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: AutoSizeText(
                          "Max Count",
                          style: TextStyle(
                              fontSize: 50,
                              fontFamily: 'PixelTitle',
                              color: Colors.black),
                          maxLines: 1,
                        ),
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
                            _liveUsers < 0
                                ? "Live Users: -"
                                : "Live Users: $_liveUsers",
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
                                SharedPreferences.getInstance().then((value) {
                                  value.setBool("wantsSounds", wantsAudio);
                                });
                              });
                            },
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
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
                        height: height * 0.03,
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
                              _initialNumber.length == 0
                                  ? "--"
                                  : _initialNumber,
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
                        height: isCoolingDown ? height * 0.04 : height * 0.065,
                      ),
                      isCoolingDown
                          ? Text(
                              "Wait $remaining seconds before trying again...",
                              style: GoogleFonts.vt323(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)))
                          : Container(),
                      SizedBox(
                        height: isCoolingDown ? height * 0.005 : 0,
                      ),
                      isCoolingDown
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.2, right: width * 0.2),
                              child: LinearProgressIndicator(
                                value: value,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    HexColor.fromHex("#fe0100")),
                                backgroundColor: Colors.white,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: height * 0.01,
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
                      ),
                      Expanded(child: Container()),
                      /*Container(
                        child: Center(child: AdWidget(ad: myBanner)),
                        width: width,
                        height: 100,
                      )
                      */
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
        _displayToastError("Please add a number before submiting");
        _playError();
      } else {
        if (isCoolingDown) {
          var list = [
            "You may want to rethink that....",
            "Wait 5 seconds between obvious mistakes...",
            "Don't insist...",
            "Are you trying to influence up the score?",
            "Come mon... rethink that again!",
            "Are you for real? You can see you have to wait",
            "Please wait for the cooldown to finish",
            "Wait for the cooldown...",
            "Take your time to think your answer",
            "Did you really want to do that?"
          ];
          final _random = Random();
          var element = list[_random.nextInt(list.length)];
          needsCooldown = true;
          _displayToastError(element);
          _playError();
        } else {
          double current = 0;
          double input = 0;
          if (_initialNumber.length > 6) {
            var remot = _initialNumber.substring(_initialNumber.length - 3);
            var local = _inputController.text
                .substring(_inputController.text.length - 3);
            current = double.parse(remot);
            input = double.parse(local);
          } else {
            current = double.parse(_initialNumber);
            input = double.parse(_inputController.text);
          }

          if (current > input + 10 || current < input - 10) {
            _displayToastError(
                "Come on... that's obviously not the next number");
            _playError();
          } else {
            if (_inputController.text != _requiredNextNumber) {
              _activateCooldown();
              if (_numLives == 1) {
                _playReset();
                _database
                    .ref("maxCount/")
                    .update({
                      "number": "0",
                      "lives": 3,
                      "totalResets": ServerValue.increment(1)
                    })
                    .then((value) {})
                    .catchError((error) =>
                        _displayToastError("We encountered a network error"));
              } else {
                await _database.ref("maxCount/").update({
                  "lives": ServerValue.increment(-1),
                });
                _playErrorNumber();
              }
            } else {
              await _database.ref("maxCount/").update({
                "number": _requiredNextNumber,
              });
              _playSuccess();
            }
          }
        }

        _inputController.clear();
      }
    } else {
      _displayToastError("Please connect to the internet");
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
    if (isCoolingDown == false) {
      isCoolingDown = true;
      FocusManager.instance.primaryFocus?.unfocus();
      value = 0;
      remaining = 10;
      Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          if (value >= 0.9) {
            isCoolingDown = false;
            needsCooldown = false;
            timer.cancel();
          } else {
            value = value + 0.1;
            if (remaining > 0) {
              remaining = remaining - 1;
            }
          }
        });
      });
      setState(() {});
    }
  }

  void _displayToastError(String title) {
    FocusManager.instance.primaryFocus?.unfocus();

    showToast(
      title,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 3),
      reverseEndOffset: Offset(0, 20),
      curve: Curves.elasticOut,
      onDismiss: () {
        if (needsCooldown == true) {
          needsCooldown = false;
          _activateCooldown();
        }
      },
      reverseCurve: Curves.linear,
    );
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
