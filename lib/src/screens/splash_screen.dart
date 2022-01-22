//FLUTTER NATIVE
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:max_count/src/models/hex_color.dart';
import 'package:max_count/src/screens/onboarding/onboarding1.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SCREENS
import 'package:max_count/src/screens/screens.dart';

//PAQUETS INSTALATS
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  static bool hasLoaded = false;
  bool wantsSounds = true;
  bool hasOnboard = false;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

void _onboardingDone(context) {
  context.widget.hasOnboard = false;
  SharedPreferences.getInstance().then((value) {
    value.setBool("hasOnboarding", false);
  });
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    if (SplashScreen.hasLoaded) {
      if (widget.hasOnboard) {
        return Onboarding1(callback: () {
          _onboardingDone(context);
          setState(() {});
        });
      } else {
        return Home(initialSounds: widget.wantsSounds);
      }
    }

    return FutureBuilder(
        future: _gestionaAsync(context), //,_gestionaAsync(),
        builder: (c, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text("Error"));
          } else if (asyncSnapshot.hasData) {
            SplashScreen.hasLoaded = true;
            if (widget.hasOnboard) {
              return Onboarding1(callback: () {
                _onboardingDone(context);
                setState(() {});
              });
            } else {
              return Home(initialSounds: widget.wantsSounds);
            }
          }
          return Material(
            type: MaterialType.transparency,
            child: Container(
                color: HexColor.fromHex("#5ED466"),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: AutoSizeText(
                      "Max Count",
                      style: TextStyle(
                          fontSize: 45,
                          fontFamily: 'PixelTitle',
                          color: Colors.black),
                      maxLines: 1,
                    ),
                  ),
                )),
          );
        });
  }

  Future _gestionaAsync(context) async {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    );

    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

    await MobileAds.instance.initialize();
    List<String> testDeviceIds = ['F7549B55838E8EC844A21FC0ACEBA956'];

    RequestConfiguration configuration =
        RequestConfiguration(testDeviceIds: testDeviceIds);
    MobileAds.instance.updateRequestConfiguration(configuration);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("wantsSounds")) {
      context.widget.wantsSounds = prefs.getBool("wantsSounds");
    } else {
      prefs.setBool("wantsSounds", true);
      context.widget.wantsSounds = true;
    }

    prefs.setBool("isLive", true);
    final _database = FirebaseDatabase.instance;
    _database.ref("maxCount/liveUsers").once().then((event) {
      int _liveUsers = int.parse(event.snapshot.value.toString());
      _liveUsers++;
      _database
          .ref("maxCount/")
          .update({"liveUsers": _liveUsers})
          .then((v) {})
          .catchError((error) => {});
    });

    if (prefs.containsKey("hasOnboarding")) {
      context.widget.hasOnboard = prefs.getBool("hasOnboarding");
    } else {
      prefs.setBool("hasOnboarding", true);
      context.widget.hasOnboard = true;
    }

    return 1;
  }
}
