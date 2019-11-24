import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();

  final String myBike;
  final String credit;

  BookingScreen({@required this.myBike,
                  @required this.credit}) : assert(myBike != null),
                                            assert(credit != null);
}

class _BookingScreenState extends State<BookingScreen> {
  var bike;
  var isTripStarted = false;
  var startTime = "-- : -- : --";
  var cardHeight = 380;

  @override
  void initState() {
    super.initState();
  }

  _getBikeDetails() async {
    var docRef =
        Firestore.instance.collection("bicycles").document(widget.myBike);
    return docRef.get();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child: Scaffold(
          // appBar: _buildAppbar(),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 520
                    ? MediaQuery.of(context).size.height
                    : 520,
                decoration: BoxDecoration(
                  color: CT.ColorTheme.homeBackground,
                ),
                child: _buildBookings(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookings() {
    return Center(
      child: FutureBuilder(
        future: _getBikeDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              {
                return new Stack(
                  alignment: Alignment.topCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.only(top: 40),
                      elevation: 10.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(33.0),
                      ),
                      child: Container(
                        width: 300,
                        height: cardHeight.toDouble(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "You have Booked",
                                style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Bike ${snapshot.data["bicycleId"]}",
                                style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 30,
                                  color: CT.ColorTheme.homeText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                child: Table(
                                  defaultColumnWidth: FlexColumnWidth(),
                                  children: <TableRow>[
                                    TableRow(
                                      children: <Widget>[
                                        Text(
                                          "Start time",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          startTime,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 22,
                                              fontFamily: "TitilliumWebBold",
                                            color: CT.ColorTheme.homeText
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: <Widget>[
                                        Text(
                                          "Fare",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: CT.ColorTheme.homeText,
                                              fontFamily: "TitilliumWebBold",
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(text: "0.00 ",),
                                              TextSpan(
                                                  text: "LKR",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: CT.ColorTheme.homeText
                                                  ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: <Widget>[
                                        Text(
                                          "Battery",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data["batteryLevel"]} %",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: CT.ColorTheme.homeText,
                                            fontFamily: "TitilliumWebBold",
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: <Widget>[
                                        Text(
                                          "Credit",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: CT.ColorTheme.homeText,
                                              fontFamily: "TitilliumWebBold",
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(text: widget.credit),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isTripStarted,
                      child: Container(
                        margin: EdgeInsets.only(top: 325.0),
                        child: SizedBox(
                          width: 175,
                          height: 60,
                          child: RaisedButton(
                            color: CT.ColorTheme.homeText,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27.0)),
                            elevation: 8,
                            highlightElevation: 2,
                            splashColor: Colors.white54,
                            onPressed: () => _lockUnlockBike(false),
                            child: Text(
                              "Unlock",
                              style: TextStyle(
                                fontFamily: "TitilliumWebBold",
                                color: Colors.white,
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sorry, Something went wrong!",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "NunitoRegular",
                        fontSize: 30,
                      ),
                    ),
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
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new HomeScreen(),
                              ),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    )
                  ],
                );
              }
          }
        },
      ),
    );
  }

  _logout() {
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false);
  }

  _lockUnlockBike(bool locked) {
    var docRef =
        Firestore.instance.collection("bicycles").document(widget.myBike);

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(docRef, {"locked": locked}).then((data) async {
        Toast.show(
          (locked) ? "Bike locked" : "Bike unlocked",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
        );

        setState(() {
          startTime = DateFormat("HH:mm:ss").format(DateTime.now());
          cardHeight = 280;
          isTripStarted = true;
        });
      });
    });
  }

  _finishTrip() {
    var docRef =
        Firestore.instance.collection("bicycles").document(widget.myBike);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(docRef, {"availability": true});
    });

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => new HomeScreen(),
        ),
        (Route<dynamic> route) => false);
  }
}
