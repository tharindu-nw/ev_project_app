import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/bookings_screen.dart';
import 'package:ev_app/screens/stations_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => new _HomeScreenState();

  final String uId;

  HomeScreen({@required this.uId}) : assert(uId != null);
}

class _HomeScreenState extends State<HomeScreen> {
  var myBike;
  var _auth = FirebaseAuth.instance;
  var _credit;
  var _onTrip = false;

  var _minCredit;
  var _helpTelephone;
  var _helpEmail;
  final _constID = "BaQFRHA9IanrJojdNRgi";

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _getConstants();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child: _buildAvailableScreen(),
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
              "Help",
              style: TextStyle(
                fontFamily: "TitilliumWebBold",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () => _showHelpDialog(),
          ),
        ),
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
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 650.0
                ? MediaQuery.of(context).size.height
                : 650.0,
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
                  child: FutureBuilder(
                    future: _getUserData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          {
                            var user = snapshot.data.data;
                            _credit =
                                double.parse(user["amount"].toStringAsFixed(2));
                            _onTrip = user["onTrip"];
                            if (_onTrip) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                _showOnTripDialog();
                              });
                            }
                            return new Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Hello ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "NunitoRegular",
                                    fontSize: 37,
                                  ),
                                ),
                                (user["name"] != null)
                                    ? Text(
                                        "${user["name"]}",
                                        style: TextStyle(
                                          color: CT.ColorTheme.homeText,
                                          fontFamily: "NunitoRegular",
                                          fontSize: 37,
                                        ),
                                      )
                                    : Text(
                                        "There!",
                                        style: TextStyle(
                                          color: CT.ColorTheme.homeText,
                                          fontFamily: "NunitoRegular",
                                          fontSize: 37,
                                        ),
                                      ),
                              ],
                            );
                          }
                        case ConnectionState.waiting:
                          {
                            return SpinKitWave(
                              color: CT.ColorTheme.homeText,
                              size: 50.0,
                            );
                          }
                        case ConnectionState.active:
                          {
                            return SpinKitWave(
                              color: CT.ColorTheme.homeText,
                              size: 50.0,
                            );
                          }
                        default:
                          {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Hello ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "NunitoRegular",
                                    fontSize: 37,
                                  ),
                                ),
                                Text(
                                  "There!",
                                  style: TextStyle(
                                    color: CT.ColorTheme.homeText,
                                    fontFamily: "NunitoRegular",
                                    fontSize: 37,
                                  ),
                                ),
                              ],
                            );
                          }
                      }
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10.0),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "Click below to start your next journey",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "NunitoRegular",
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    )),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text(
                        "Select Station",
                        style: TextStyle(
                          fontFamily: "TitilliumWebBold",
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    onPressed: () => _validateCredit(),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.uId)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          {
                            _credit = double.parse(
                                snapshot.data["amount"].toStringAsFixed(2));
                            return (snapshot.hasData)
                                ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Trips : ${snapshot.data["tripsCount"].toString()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "NunitoRegular",
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        "Credit :  ${snapshot.data["amount"].toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: CT.ColorTheme.homeText,
                                          fontFamily: "NunitoRegular",
                                          fontSize: 22,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container();
                          }
                        case ConnectionState.waiting:
                          {
                            return SpinKitWave(
                              color: CT.ColorTheme.homeText,
                              size: 50.0,
                            );
                          }
                        case ConnectionState.active:
                          {
                            _credit = double.parse(
                                snapshot.data["amount"].toStringAsFixed(2));
                            return (snapshot.hasData)
                                ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Trips : ${snapshot.data["tripsCount"].toString()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "NunitoRegular",
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        "Credit :  ${snapshot.data["amount"].toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: CT.ColorTheme.homeText,
                                          fontFamily: "NunitoRegular",
                                          fontSize: 22,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container();
                          }
                        default:
                          {
                            return Container();
                          }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getConstants() {
    DocumentReference constDoc =
        Firestore.instance.collection("constants").document(_constID);
    constDoc.get().then((value) {
      if (value.exists) {
        _minCredit = value.data['minFare'];
        _helpTelephone = value.data['contact'];
        _helpEmail = value.data['email'];
      }
    });
  }

  Future<void> _validateCredit() async {
    FirebaseUser user = await _auth.currentUser();
    var userDocRef = Firestore.instance.collection("users").document(user.uid);
    userDocRef.get().then((DocumentSnapshot snap) {
      if (snap.exists) {
        _credit = double.parse(snap.data["amount"].toStringAsFixed(2));
        if (_minCredit != null && _credit >= _minCredit) {
          _openStationsScreen();
        } else if (_minCredit != null) {
          _showLowCreditDialog();
        }
      }
    });
  }

  void _showLowCreditDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Low Credit",
            style: TextStyle(
                color: CT.ColorTheme.homeText, fontFamily: "NunitoRegular"),
          ),
          elevation: 24.0,
          backgroundColor: CT.ColorTheme.homeBackground,
          content: Text(
            "Sorry you seem to be low on credit. You need to have more than $_minCredit credit to start a trip.",
            style: TextStyle(color: Colors.white, fontFamily: "NunitoRegular"),
          ),
          actions: <Widget>[
            FlatButton(
                child: new Text(
                  "Close",
                  style: TextStyle(
                      color: CT.ColorTheme.homeText,
                      fontFamily: "NunitoRegular"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Contact Us",
            style: TextStyle(
                color: CT.ColorTheme.homeText, fontFamily: "NunitoRegular"),
          ),
          elevation: 24.0,
          backgroundColor: CT.ColorTheme.homeBackground,
          content: Text(
            "Call: $_helpTelephone\nEmail:$_helpEmail",
            style: TextStyle(color: Colors.white, fontFamily: "NunitoRegular"),
          ),
          actions: <Widget>[
            FlatButton(
                child: new Text(
                  "Close",
                  style: TextStyle(
                      color: CT.ColorTheme.homeText,
                      fontFamily: "NunitoRegular"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  void _showOnTripDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Continue Trip",
            style: TextStyle(
                color: CT.ColorTheme.homeText, fontFamily: "NunitoRegular"),
          ),
          elevation: 24.0,
          backgroundColor: CT.ColorTheme.homeBackground,
          content: Text(
            "You have an unfinished trip. Click to continue",
            style: TextStyle(color: Colors.white, fontFamily: "NunitoRegular"),
          ),
          actions: <Widget>[
            FlatButton(
                child: new Text(
                  "Continue Ongoing Trip",
                  style: TextStyle(
                      color: CT.ColorTheme.homeText,
                      fontFamily: "NunitoRegular"),
                ),
                onPressed: () {
                  _openOngoingTrip();
                })
          ],
        );
      },
    );
  }

  Future<void> _openOngoingTrip() async {
    final bikeQuery = Firestore.instance
        .collection("bicycles")
        .where("currentUserId", isEqualTo: widget.uId);

    bikeQuery.getDocuments().then((QuerySnapshot snap) {
      if (snap.documents.isNotEmpty) {
        var bikeId = snap.documents[0].documentID;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                onTrip: true,
                bikeId: bikeId,
              ),
            ),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  Future<DocumentSnapshot> _getUserData() async {
    FirebaseUser user = await _auth.currentUser();
    var userDocRef = Firestore.instance.collection("users").document(user.uid);

    // userDocRef.get().then((DocumentSnapshot snapshot) {
    //   if (snapshot.exists) {
    //     var user = snapshot.data;
    //     _credit = double.parse(user["amount"].toStringAsFixed(2));
    //     _name = user['name'];
    //   }
    // });

    return userDocRef.get();
  }

  _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false);
  }

  _openStationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new StationsScreen(credit: _credit.toString()),
      ),
    );
  }
}
