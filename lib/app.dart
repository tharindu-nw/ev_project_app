import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "TitilliumWeb",
        textTheme: Theme.of(context).textTheme,
      ),
      home: Scaffold(
        body: Center(
          child: Text(
            "The Font is working!",
            style: TextStyle(
              fontSize: 40,
              // fontFamily: "Nunito",
            ),
          ),
        ),
      ),
    );
  }
}
