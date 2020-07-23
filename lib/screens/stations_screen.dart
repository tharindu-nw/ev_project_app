import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/start_journey_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ev_app/widgets/cards/easyBadgeCard.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StationsScreen extends StatefulWidget {
  _StationsScreenState createState() => new _StationsScreenState();

  final String credit;

  StationsScreen({@required this.credit}) : assert(credit != null);
}

class _StationsScreenState extends State<StationsScreen> {
  PanelController _pc = new PanelController();
  var myBike;

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
      child: _buildStationsScreen(),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: CT.ColorTheme.homeBackground,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                fontFamily: "TitilliumWebBold",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () => _logout(),
          ),
        ),
      ],
    );
  }

  Widget _buildCycleList() {
    return StreamBuilder(
      stream: Firestore.instance.collection("stations").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading...");
        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = snapshot.data.documents[index];
            return EasyBadgeCard(
              leftBadge: Colors.white,
              prefixIcon: FontAwesomeIcons.bicycle,
              prefixIconColor: Color(0xFF160F29),
              backgroundColor: CT.ColorTheme.cardBackground,
              title: "${doc['name']}",
              titleColor: Color(0xFF160F29),
              descriptionColor: Color(0xFF160F29),
              suffixIcon: Icons.arrow_forward_ios,
              suffixIconColor: Color(0xFF160F29),
              onTap: () => _openStartJourneyScreen(doc['name']),
            );
          },
        );
      },
    );
  }

  Widget _buildStationsScreen() {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SlidingUpPanel(
        controller: _pc,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 550.0
                  ? MediaQuery.of(context).size.height
                  : 550.0,
              decoration: BoxDecoration(
                color: CT.ColorTheme.homeBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Available ",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "NunitoRegular",
                            fontSize: 37,
                          ),
                        ),
                        Text(
                          "Stations",
                          style: TextStyle(
                            color: CT.ColorTheme.homeText,
                            fontFamily: "NunitoRegular",
                            fontSize: 37,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: _buildCycleList()),
                  /*RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "NunitoRegular",
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "There are "),
                        // TextSpan(
                        //   text: "5",
                        //   style: TextStyle(
                        //     color: CT.ColorTheme.homeText,
                        //     fontFamily: "NunitoRegular",
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        TextSpan(
                            text:
                            "bikes available at the dock right now. Click below to start your journey"),
                      ],
                    ),
                  ),*/
                  /*Container(
                    margin: EdgeInsets.only(top: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: CT.ColorTheme.homeText,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: CT.ColorTheme.loginGradientStart,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          "Select Station",
                          style: TextStyle(
                            fontFamily: "TitilliumWebBold",
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      onPressed: () => _bookNow(),
                    ),
                  )*/
                ],
              ),
            ),
          ),
        ),
        panel: Center(
          //no longer used
          child: Text("Hello!"),
        ),
        backdropEnabled: true,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black87,
            blurRadius: 15.0,
          )
        ],
      ),
    );
  }

  _logout() {
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false);
  }

  _openStartJourneyScreen(String stationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            new StartJourneyScreen(stationId: stationId, credit: widget.credit),
      ),
    );
  }
}
