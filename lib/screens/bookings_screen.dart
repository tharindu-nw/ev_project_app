import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:ev_app/utils/mock_data.dart';
import 'package:ev_app/widgets/navigation/navbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();

  final String myBike;

  BookingScreen({@required this.myBike}) : assert(myBike != null);
}

class _BookingScreenState extends State<BookingScreen> {
  var _cIndex = 1;
  var bike;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  _getBikeDetails() {
    var docRef =
        Firestore.instance.collection("bicycles").document(widget.myBike);
    return docRef.get();
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
          bottomNavigationBar: Navbar(
            currentIndex: 1,
          )),
    );
  }

  Widget _buildBookings() {
    return FutureBuilder(
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
                    elevation: 10.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(33.0),
                    ),
                    child: Container(
                      width: 300,
                      height: 450,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 300.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: CT.ColorTheme.homeText,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black87,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      highlightColor: Colors.transparent,
                      splashColor: CT.ColorTheme.loginGradientStart,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 35.0),
                        child: Text(
                          "Unlock",
                          style: TextStyle(
                            fontFamily: "TitilliumWebBold",
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      onPressed: () => _lockUnlockBike(false),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 365.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.red,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black87,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      highlightColor: Colors.transparent,
                      splashColor: CT.ColorTheme.loginGradientStart,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 35.0),
                        child: Text(
                          "Lock",
                          style: TextStyle(
                            fontFamily: "TitilliumWebBold",
                            color: Colors.white,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                      onPressed: () => _lockUnlockBike(true),
                    ),
                  ),
                ],
              );
            }
          default:
            {
              return SpinKitFoldingCube(
                color: Colors.white,
                size: 50.0,
              );
            }
        }
      },
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

  _logout() {
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false);
  }

  _lockUnlockBike(bool locked) {
    var docRef =
        Firestore.instance.collection("bicycles").document(widget.myBike);

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(docRef, {"locked": locked});
    });
  }
}
