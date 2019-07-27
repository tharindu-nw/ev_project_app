import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ev_app/components/cards/easyBadgeCard.dart';
import 'package:ev_app/utils/mock_data.dart';

final _padding = EdgeInsets.only(top: 20.0);
final _bigPadding = EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0);
final _themeColor = Color(0xFF090446);

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildCycleList(),
                ],
              ),
              //  color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: _buildNavBar(),
      ),
    );
  }

  Widget _buildNavBar() {
    return BottomNavigationBar(
      currentIndex: _cIndex,
      type: BottomNavigationBarType.shifting,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.home,
            color: _themeColor,
          ),
          title: Text(
            "Available",
            style: TextStyle(
              color: _themeColor,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.key,
            color: _themeColor,
          ),
          title: Text(
            "My Bookings",
            style: TextStyle(
              color: _themeColor,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.question,
            color: _themeColor,
          ),
          title: Text(
            "Help",
            style: TextStyle(
              color: _themeColor,
            ),
          ),
        ),
      ],
      onTap: (index) {
        _incrementTab(index);
      },
    );
  }

  Widget _buildCycleList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: CT.ColorTheme.homeGradient,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: mockData.bikes.length,
        itemBuilder: (BuildContext context, int index) {
          return EasyBadgeCard(
            leftBadge: Colors.white,
            prefixIcon: FontAwesomeIcons.bicycle,
            prefixIconColor: _themeColor,
            backgroundColor: _themeColor,
            title: mockData.bikes[index][0],
            description: 'Rating: ${mockData.bikes[index][1]}',
            titleColor: Colors.white,
            descriptionColor: Colors.white,
            suffixIcon: Icons.arrow_forward_ios,
            suffixIconColor: Colors.white,
          );
        },
      ),
    );
  }
}
