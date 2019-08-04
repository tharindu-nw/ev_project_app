import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;

class Navbar extends StatelessWidget {
  final int currentIndex;

  Navbar({@required this.currentIndex}) : assert(currentIndex != null);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      iconSize: 20.0,
      elevation: 16,
      showUnselectedLabels: false,
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
      selectedItemColor: CT.ColorTheme.loginGradientStart,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            "Available",
            style: TextStyle(),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.lock_outline,
          ),
          title: Text(
            "My Bookings",
            style: TextStyle(),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.help_outline,
          ),
          title: Text(
            "Help",
            style: TextStyle(),
          ),
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/", (Route<dynamic> route) => false);
            }
            break;
          case 1:
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/bookings", (Route<dynamic> route) => false);
            }
            break;
        }
      },
    );
  }
}
