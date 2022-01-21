// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:max_count/src/models/hex_color.dart';
import 'package:max_count/src/screens/home.dart';
import 'package:max_count/src/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nice_intro/intro_screen.dart';
import 'package:nice_intro/intro_screens.dart';

class WelcomeScreen extends StatefulWidget {
  bool wantsSound;

  Function callback;

  WelcomeScreen({required this.wantsSound, required this.callback});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  _updatePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //value.setBool("hasOnboarding", false);
    print("Es posaria a fals");
  }

  @override
  Widget build(BuildContext context) {
    List<IntroScreen> pages = [
      IntroScreen(
        textStyle: GoogleFonts.vt323(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        title: 'Welcome to Max Count',
        imageAsset: 'assets/heart.png',
        description: 'Compete with other players to count as high as possible.',
        headerBgColor: HexColor.fromHex("#5ED466"),
      ),
      IntroScreen(
        textStyle: GoogleFonts.vt323(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        title: 'Be careful!',
        headerPadding: EdgeInsets.all(10),
        headerBgColor: HexColor.fromHex("#5ED466"),
        imageAsset: 'assets/heart.png',
        description:
            "If you input the wrong number you will be penalized with a life. If you loose all three the counter restarts. Globally.",
      ),
      IntroScreen(
        textStyle: GoogleFonts.vt323(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        title: 'Take your time, and enjoy!',
        headerBgColor: HexColor.fromHex("#5ED466"),
        imageAsset: 'assets/heart.png',
        description: "",
      ),
    ];

    return Scaffold(
        backgroundColor: HexColor.fromHex("#5ED466"),
        body: SafeArea(
          child: IntroScreens(
            onDone: () {
              widget.callback();
            },
            onSkip: () {
              widget.callback();
            },
            footerBgColor: Colors.white,
            activeDotColor: Colors.black,
            footerRadius: 20.0,
            viewPortFraction: 1,
            indicatorType: IndicatorType.CIRCLE,
            slides: pages,
            textColor: Colors.black,
          ),
        ));
  }
}
