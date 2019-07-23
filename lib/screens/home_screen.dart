import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ev_app/shared/navigation_bar.dart';
import 'package:ev_app/shared/navigation_bar_item.dart';

final _padding = EdgeInsets.only(top: 20.0);
final _bigPadding = EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0);

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: CT.ColorTheme.gradient,
              ),
              child: _buildNavBar(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TitledBottomNavigationBar(
        items: [
          TitledNavigationBarItem(
            icon: Icons.person_outline,
            title: "Profile",
          ),
          TitledNavigationBarItem(
            icon: Icons.home,
            title: "Home",
          ),
          TitledNavigationBarItem(
            icon: Icons.help_outline,
            title: "Help",
          ),
        ],
      ),
    );
  }
}
