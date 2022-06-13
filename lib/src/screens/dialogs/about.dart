//FLUTTER NATIVE
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens.dart';

// ignore: must_be_immutable
class AboutMaxCount extends StatefulWidget {
  @override
  _AboutMaxCountState createState() => _AboutMaxCountState();
}

class _AboutMaxCountState extends State<AboutMaxCount> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: Container(
        height: height * 0.2,
        width: width * 0.7,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("About Kobolo",
                  style: GoogleFonts.vt323(
                      textStyle: TextStyle(
                          fontSize: shortestSide < 600 ? 25 : 35,
                          fontWeight: FontWeight.bold))),
              SizedBox(
                height: 5,
              ),
              Text("1.2.0"),
              SizedBox(
                height: 10,
              ),
              Text(
                "Author",
                style: GoogleFonts.vt323(
                    textStyle: TextStyle(
                        fontSize: shortestSide < 600 ? 25 : 35,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Victor Xirau"),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      SharedPreferences.getInstance().then((value) {
                        SplashScreen.hasLoaded = false;
                        value.setBool("hasOnboarding", false);
                        Future.microtask(
                            () => Navigator.pushReplacementNamed(context, "/"));
                      });
                    },
                    child: AutoSizeText(
                      'How to play',
                      style: GoogleFonts.vt323(
                          textStyle: TextStyle(
                              color: Colors.green,
                              fontSize: shortestSide < 600 ? 18 : 25,
                              fontWeight: FontWeight.bold)),
                      maxLines: 1,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 15, color: Colors.green),
                    ),
                    onPressed: () async {
                      const url = "https://victorxirau.tech";
                      //if (!await launch(url)) ;
                    },
                    child: AutoSizeText(
                      'Visit Website',
                      style: GoogleFonts.vt323(
                          textStyle: TextStyle(
                              color: Colors.green,
                              fontSize: shortestSide < 600 ? 18 : 25,
                              fontWeight: FontWeight.bold)),
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
