import 'package:ev_app/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/": (BuildContext context) => new LandingScreen(),
    // "/available": (BuildContext context) => new StartJourneyScreen(),
    // "/bookings": (BuildContext context) => new BookingScreen(),
    "/login": (BuildContext context) => new LoginScreen(),
    // "/stations": (BuildContext context) => new StationsScreen(),
  };

  Routes() {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "TitilliumWebReg",
        ),
        initialRoute: "/",
        routes: routes,
      ),
    );
  }
}
