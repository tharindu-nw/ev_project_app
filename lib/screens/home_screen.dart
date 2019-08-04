import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ev_app/widgets/cards/easyBadgeCard.dart';
import 'package:ev_app/utils/mock_data.dart';
import 'package:ev_app/widgets/navigation/navbar.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _cIndex = 0;

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
          appBar: _buildAppbar(),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: CT.ColorTheme.loginGradient,
              ),
              child: _buildCycleList(),
            ),
          ),
          bottomNavigationBar: Navbar(
            currentIndex: 0,
          )),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        "Available Bikes",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 30.0,
        ),
      ),
    );
  }

  Widget _buildCycleList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: mockData.bikes.length,
      itemBuilder: (BuildContext context, int index) {
        return EasyBadgeCard(
          leftBadge: Colors.white,
          prefixIcon: FontAwesomeIcons.bicycle,
          prefixIconColor: Color(0xFF160F29),
          backgroundColor: CT.ColorTheme.cardBackground,
          title: mockData.bikes[index][0],
          description: 'Rating: ${mockData.bikes[index][1]}',
          titleColor: Color(0xFF160F29),
          descriptionColor: Color(0xFF160F29),
          suffixIcon: Icons.arrow_forward_ios,
          suffixIconColor: Color(0xFF160F29),
        );
      },
    );
  }
}
