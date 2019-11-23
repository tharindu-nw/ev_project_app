import 'package:ev_app/screens/start_journey_screen.dart';
import 'package:ev_app/screens/stations_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bookings_screen.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/": (BuildContext context) => new HomeScreen(),
    "/available": (BuildContext context) => new StartJourneyScreen(),
    // "/bookings": (BuildContext context) => new BookingScreen(),
    "/login": (BuildContext context) => new LoginScreen(),
    "/stations": (BuildContext context) => new StationsScreen(),
  };

  Routes() {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "TitilliumWebReg",
        ),
        initialRoute: "/login",
        routes: routes,
      ),
    );
  }
}
