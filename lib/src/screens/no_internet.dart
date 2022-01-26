// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:max_count/src/models/hex_color.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NoInternet extends StatefulWidget {
  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  late RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "No internet connection!",
                                style: GoogleFonts.vt323(
                                    textStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0, bottom: 8.0, left: 20, right: 20),
                                child: Text(
                                  "Please connect to the internet to use the app.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.vt323(
                                      textStyle: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.25,
                              ),
                              RoundedLoadingButton(
                                borderRadius: 10,
                                color: HexColor.fromHex("#fe0100"),
                                successColor: HexColor.fromHex("#fe0100"),
                                errorColor: HexColor.fromHex("#fe0100"),
                                failedIcon: Icons
                                    .signal_wifi_connected_no_internet_4_sharp,
                                child: Text('Retry',
                                    style: GoogleFonts.vt323(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                controller: _btnController,
                                onPressed: _comprovaConnexio,
                              )
                            ]),
                      )
                    ])))));
  }

  void _comprovaConnexio() {
    Timer(Duration(seconds: 1), () {
      if (Provider.of<InternetConnectionStatus>(context, listen: false) ==
          InternetConnectionStatus.disconnected) {
        _btnController.error();
        Timer(Duration(seconds: 1), () {
          setState(() {
            _btnController.reset();
          });
        });
      } else {
        _btnController.success();
        Timer(Duration(seconds: 1), () {
          setState(() {
            _btnController.reset();
          });
        });
      }
    });
  }
}
