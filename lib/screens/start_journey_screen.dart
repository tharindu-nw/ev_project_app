import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/bookings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ev_app/widgets/cards/easyBadgeCard.dart';
import 'package:ev_app/widgets/navigation/navbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StartJourneyScreen extends StatefulWidget {
  @override
  _StartJourneyScreenState createState() => new _StartJourneyScreenState();

  final String stationId;
  final String credit;

  StartJourneyScreen({@required this.stationId, @required this.credit}) : assert(stationId != null),
                                                                          assert(credit != null);
}

class _StartJourneyScreenState extends State<StartJourneyScreen> {
  PanelController _pc = new PanelController();
  var myBike = null;
  var _auth = FirebaseAuth.instance;

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
        child: FutureBuilder(
          future: _getAvailability(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  if(snapshot.data.documents.isNotEmpty){
                    return _buildAvailableScreen();
                  }else{
                    return _buildBookedScreen();
                  }
                  break;
                }
              case ConnectionState.waiting:
                {
                  return SpinKitCubeGrid(
                    color: CT.ColorTheme.homeText,
                    size: 50.0,
                  );
                }
              case ConnectionState.active:
                {
                  return SpinKitCubeGrid(
                    color: CT.ColorTheme.homeText,
                    size: 50.0,
                  );
                }
              default:
                {
                  return _buildBookedScreen();
                }
            }
          },
        ),
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

  Widget _buildAvailableScreen() {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SlidingUpPanel(
        controller: _pc,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
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
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: new Image(
                        width: 250.0,
                        height: 250.0,
                        fit: BoxFit.fill,
                        image: new AssetImage('assets/img/home_bike.png')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Bikes ",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "NunitoRegular",
                            fontSize: 37,
                          ),
                        ),
                        Text(
                          "Available",
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
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "There are bikes available at the dock right now. Clic here to start your journey",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "NunitoRegular",
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
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
                  Container(
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
                            vertical: 8.0, horizontal: 35.0),
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                            fontFamily: "TitilliumWebBold",
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      onPressed: () => _bookNow(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        panel: Center(
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

  Widget _buildBookedScreen() {
    return Scaffold(
      appBar: _buildAppbar(),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 480.0
                ? MediaQuery.of(context).size.height
                : 480.0,
            decoration: BoxDecoration(
              color: CT.ColorTheme.homeBackground,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: new Image(
                      width: 250.0,
                      height: 250.0,
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/img/home_walk.png')),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Sorry, we are ",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "NunitoRegular",
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        "booked",
                        style: TextStyle(
                          color: CT.ColorTheme.warningText,
                          fontFamily: "NunitoRegular",
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    "Currently there are no bikes available at the dock. Please check again in a short while",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "NunitoRegular",
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _logout() {
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false);
  }

  Future<QuerySnapshot> _getAvailability() async {
    var availableQuery = Firestore.instance
        .collection("bicycles")
        .where("stationId", isEqualTo: widget.stationId)
        .where("availability", isEqualTo: true);

    return await availableQuery.getDocuments();
  }

  _bookNow() async {
    var availableQuery = Firestore.instance
        .collection("bicycles")
        .where("stationId", isEqualTo: widget.stationId)
        .where("availability", isEqualTo: true)
        .limit(1);

    await availableQuery.getDocuments().then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        myBike = docs.documents[0].documentID;

        var docRef = Firestore.instance.collection("bicycles").document(myBike);

        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(docRef, {"availability": false});
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => new BookingScreen(myBike: myBike, credit: widget.credit,),
            ),
            (Route<dynamic> route) => false);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => new BookingScreen(myBike: myBike),
        //   ),
        // );
      }
    });
  }
}
