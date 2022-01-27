//FLUTTER NATIVE
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

//PAQUETS INSTALATS
import 'package:google_fonts/google_fonts.dart';
import 'package:max_count/src/models/hex_color.dart';
import 'package:max_count/src/screens/onboarding/onboarding1.dart';
import 'package:max_count/src/screens/onboarding/onboarding2.dart';

//SCREENS
import 'package:max_count/src/screens/screens.dart';
import 'package:max_count/src/widgets/circular_button.dart';
import 'package:max_count/src/widgets/route_animations/reveal_route.dart';
import 'package:max_count/src/widgets/status_bars.dart';

class Onboarding4 extends StatefulWidget {
  Function callback;

  Onboarding4({required this.callback});

  @override
  _Onboarding4State createState() => _Onboarding4State();
}

class _Onboarding4State extends State<Onboarding4> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      backgroundColor: HexColor.fromHex("#5ED466"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.025,
              ),
              StatusBars(
                  position: 4,
                  totalElements: 4,
                  selectedColor: Colors.black,
                  unselectedColor: Colors.black45),
              SizedBox(
                height: height * 0.025,
              ),
              AutoSizeText(
                "Max Count",
                style: TextStyle(
                    fontSize: shortestSide < 600 ? 50 : 80,
                    fontFamily: 'PixelTitle',
                    color: Colors.black),
                maxLines: 1,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "And finally...",
                    style: GoogleFonts.vt323(
                        textStyle: TextStyle(
                            fontSize: shortestSide < 600 ? 40 : 60,
                            fontWeight: FontWeight.bold)),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    "Remember to have fun ;)!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vt323(
                        textStyle: TextStyle(
                            fontSize: shortestSide < 600 ? 25 : 35,
                            fontWeight: FontWeight.bold)),
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                      borderRadius: shortestSide < 600
                          ? BorderRadius.circular(10.0)
                          : BorderRadius.circular(20.0),
                      child: Container(
                        height: shortestSide < 600 ? null : width * 0.5,
                        width: shortestSide < 600 ? width * 0.8 : null,
                        child: Center(
                          child: Image.asset(
                            'assets/fun.gif',
                            fit: BoxFit.contain,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              )),
              ElevatedButton(
                  onPressed: () {
                    widget.callback();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: HexColor.fromHex("#fe0100"),
                      side: BorderSide(width: 3.0, color: Colors.black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      minimumSize: shortestSide < 600
                          ? Size(width * 0.5, 60)
                          : Size(width * 0.5, 80)),
                  child: AutoSizeText(
                    "Finish",
                    style: GoogleFonts.vt323(
                        textStyle: TextStyle(
                            fontSize: shortestSide < 600 ? 20 : 40,
                            fontWeight: FontWeight.bold)),
                    maxLines: 1,
                  )),
              SizedBox(
                height: height * 0.035,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
