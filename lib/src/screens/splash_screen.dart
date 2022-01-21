//FLUTTER NATIVE
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:max_count/src/models/hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SCREENS
import 'package:max_count/src/screens/screens.dart';

//PAQUETS INSTALATS
import 'package:firebase_core/firebase_core.dart';

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
        return WelcomeScreen(
            wantsSound: widget.wantsSounds,
            callback: () {
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
              return WelcomeScreen(
                  wantsSound: widget.wantsSounds,
                  callback: () {
                    _onboardingDone(context);
                    setState(() {});
                  });
            } else {
              return Home(initialSounds: widget.wantsSounds);
            }
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

  Future _gestionaAsync(context) async {
    await Firebase.initializeApp();
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

    if (prefs.containsKey("hasOnboarding")) {
      context.widget.hasOnboard = prefs.getBool("hasOnboarding");
    } else {
      prefs.setBool("hasOnboarding", true);
      context.widget.hasOnboard = true;
    }

    return 1;
  }
}
