//FLUTTER NATIVE
import 'package:flutter/material.dart';

//SCREENS
import 'package:max_count/src/screens/screens.dart';

final Map<String, WidgetBuilder> rutes = <String, WidgetBuilder>{
  '/': (BuildContext context) => SplashScreen()
};

Map<String, WidgetBuilder> getApplicationRoutes() {
  return rutes;
}
