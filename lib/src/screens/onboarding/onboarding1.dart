//FLUTTER NATIVE
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

//PAQUETS INSTALATS
import 'package:google_fonts/google_fonts.dart';
import 'package:max_count/src/models/hex_color.dart';
import 'package:max_count/src/screens/onboarding/onboarding2.dart';

//SCREENS
import 'package:max_count/src/screens/screens.dart';
import 'package:max_count/src/widgets/circular_button.dart';
import 'package:max_count/src/widgets/route_animations/reveal_route.dart';
import 'package:max_count/src/widgets/status_bars.dart';

class Onboarding1 extends StatefulWidget {
  Function callback;

  Onboarding1({required this.callback});

  @override
  _Onboarding1State createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
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
                  position: 1,
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
                height: height * 0.1,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "Welcome!",
                    style: GoogleFonts.vt323(
                        textStyle: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    "Compete with other players to count as high as possible.",
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
                      child: Image.asset('assets/intro.gif'),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          RevealRoute(
                              page: SplashScreen(),
                              maxRadius: height * 2,
                              centerAlignment: Alignment.bottomLeft,
                              centerOffset: Offset(0, 0),
                              minRadius: 0));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(child: Container()),
                  CircularButton(
                    color: HexColor.fromHex("#fe0100"),
                    splashColor: HexColor.fromHex("#fe0100").withAlpha(10),
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      )
                    ],
                    onTap: () {
                      Navigator.push(
                          context,
                          RevealRoute(
                              page: Onboarding2(callback: widget.callback),
                              maxRadius: height * 2,
                              centerAlignment: Alignment.bottomRight,
                              centerOffset: Offset(0, 0),
                              minRadius: 0));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
