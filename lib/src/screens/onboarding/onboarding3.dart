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

class Onboarding3 extends StatefulWidget {
  Function callback;

  Onboarding3({required this.callback});

  @override
  _Onboarding3State createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: HexColor.fromHex("#5ED466"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.025,
              ),
              StatusBars(
                  position: 3,
                  totalElements: 3,
                  selectedColor: Colors.black,
                  unselectedColor: Colors.black45),
              SizedBox(
                height: height * 0.025,
              ),
              AutoSizeText(
                "Max Count",
                style: TextStyle(
                    fontSize: 50,
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
                            fontSize: 40, fontWeight: FontWeight.bold)),
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
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: width * 0.9,
                        child: Center(
                          child: Image.asset('assets/fun.gif'),
                        ),
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        widget.callback();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: HexColor.fromHex("#fe0100"),
                          side: BorderSide(width: 3.0, color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          minimumSize: Size(width * 0.5, 60)),
                      child: AutoSizeText(
                        "Finish",
                        style: GoogleFonts.vt323(
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        maxLines: 1,
                      ))
                ],
              ),
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
