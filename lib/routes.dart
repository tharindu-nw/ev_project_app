import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bookings_screen.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/": (BuildContext context) => new HomeScreen(),
    "/available": (BuildContext context) => new HomeScreen(),
    // "/bookings": (BuildContext context) => new BookingScreen(),
    "/login": (BuildContext context) => new LoginScreen(),
  };

  Routes() {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "TitilliumWebReg",
        ),
        initialRoute: "/available",
        routes: routes,
      ),
    );
  }
}
