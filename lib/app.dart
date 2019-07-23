import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "TitilliumWebReg",
        textTheme: Theme.of(context).textTheme,
      ),
      home: HomeScreen(),
    );
  }
}
