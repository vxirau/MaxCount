//FLUTTER NATIVE
import 'package:flutter/material.dart';

//ROUTES
import 'package:max_count/src/routes/routes.dart';

//PAQUETS INSTALATS
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(MaxCount());
}

class MaxCount extends StatefulWidget {
  @override
  _MaxCountState createState() => _MaxCountState();
}

class _MaxCountState extends State<MaxCount> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Max Count',
        initialRoute: '/',
        routes: getApplicationRoutes());
  }
}
