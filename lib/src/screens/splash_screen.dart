//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'package:max_count/src/models/hex_color.dart';

//SCREENS
import 'package:max_count/src/screens/home.dart';

//PAQUETS INSTALATS
import 'package:firebase_core/firebase_core.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  static bool hasLoaded = false;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    if (SplashScreen.hasLoaded) return Home();

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (c, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text("Error"));
          } else if (asyncSnapshot.connectionState == ConnectionState.done) {
            SplashScreen.hasLoaded = true;
            return Home();
          }
          return Container(
              color: HexColor.fromHex("#5ED466"),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  CircularProgressIndicator(
                    color: Colors.white,
                  )
                ],
              ));
        });
  }
}
