import 'package:ev_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;

class LandingScreen extends StatefulWidget {
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: CT.ColorTheme.launchBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: new Image(
                width: 100.0,
                height: 100.0,
                fit: BoxFit.fill,
                image: new AssetImage('assets/img/bike_icon.png'),
              ),
            ),
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(CT.ColorTheme.warningText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (user != null) {
        //open home
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => new HomeScreen(uId: user.uid),
            ),
            (Route<dynamic> route) => false);
      } else {
        //open login
        Navigator.pushNamedAndRemoveUntil(
            context, "/login", (Route<dynamic> route) => false);
      }
    });
  }
}
