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
  final String bikeId;

  BookingScreen({@required this.myBike, @required this.credit, @required this.bikeId})
      : assert(myBike != null),
        assert(bikeId != null),
        assert(credit != null);
}

class _BookingScreenState extends State<BookingScreen> {
  var bike;
  var lockRequestSent = false;
  var isButtonVisible = true;
  var isTripStarted = false;
  var isTripFinished = false;
  var startTime = "-- : -- : --";
  var cardHeight = 380;

  @override
  void initState() {
    super.initState();
  }

  _getBikeDetails() async {

    var availableQuery = Firestore.instance
        .collection("bicycles")
        .where("bicycleId", isEqualTo: widget.myBike);

    return await availableQuery.getDocuments();
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
                child: lockRequestSent
                    ? _buildLoading()
                    : _buildBookings(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
        child: Stack(
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
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("bicycles")
                    .where("bicycleId", isEqualTo: widget.myBike)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text("Loading...");
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = snapshot.data.documents[index];
                      if (doc['locked'] == true && doc['unlocking'] == true && doc['secretKey'] == null) {
                        return SpinKitCubeGrid(
                          color: CT.ColorTheme.homeText,
                          size: 50.0,
                        );
                      } else if(doc['locked'] == true && doc['unlocking'] == true && doc['secretKey'] != null){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "You have Booked",
                              style: TextStyle(
                                fontFamily: "TitilliumWebBold",
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Bike ${widget.myBike}",
                              style: TextStyle(
                                fontFamily: "TitilliumWebBold",
                                fontSize: 30,
                                color: CT.ColorTheme.homeText,
                              ),
                            ),
                            Text(
                              "Your Unlock Code is",
                              style: TextStyle(
                                fontFamily: "TitilliumWebBold",
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "${snapshot.data.documents[0]["secretKey"]}",
                              style: TextStyle(
                                fontFamily: "TitilliumWebBold",
                                fontSize: 40,
                                color: CT.ColorTheme.homeText,
                              ),
                            ),
                            Text(
                              "Enter this code in the keypad to unlock the bike",
                              style: TextStyle(
                                fontFamily: "TitilliumWebBold",
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      } else if(doc['locked'] == false && doc['unlocking'] == false) {
                        isTripStarted = true;
                        lockRequestSent = false;
                        startTime = DateFormat.Hms().format(new DateTime.now());
                        return Column(
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
                                "Bike ${snapshot.data.documents[0]["bicycleId"]}",
                                style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 30,
                                  color: CT.ColorTheme.homeText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 16.0),
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
                                              color: CT.ColorTheme.homeText),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "Your trip has started",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 24,
                                  color: CT.ColorTheme.loginGradientStart
                                ),
                              ),
                              Text(
                                "Lock the bike into the station at the end of your trip to finish",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          );
                      } else if(doc['locked'] == true && doc['unlocking'] == false && isTripStarted){
                        isTripStarted = false; 
                        isTripFinished = true;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Your trip has finished",
                                style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 20,
                                ),
                            ),
                            Visibility(
                                visible: isTripFinished,
                                child: Container(
                                  margin: EdgeInsets.only(top: 150.0),
                                  alignment:Alignment.center,
                                  child: SizedBox(
                                    width: 175,
                                    height: 60,
                                    child: RaisedButton(
                                      color: CT.ColorTheme.loginGradientStart,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(27.0)),
                                      elevation: 8,
                                      highlightElevation: 2,
                                      splashColor: Colors.white54,
                                      onPressed: () => _finishTrip(),
                                      child: Text(
                                        "Finish",
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
                      } else {
                        return SpinKitCubeGrid(
                          color: CT.ColorTheme.homeText,
                          size: 50.0,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    ));
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
                                "Bike ${snapshot.data.documents[0]["bicycleId"]}",
                                style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 30,
                                  color: CT.ColorTheme.homeText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 16.0),
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
                                              color: CT.ColorTheme.homeText),
                                        ),
                                      ],
                                    ),
                                    //TODO: Add more details to the trip card
                                    // TableRow(
                                    //   children: <Widget>[
                                    //     Text(
                                    //       "Fare",
                                    //       style: TextStyle(
                                    //         fontSize: 22,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //     RichText(
                                    //       text: TextSpan(
                                    //         style: TextStyle(
                                    //           fontSize: 22,
                                    //           color: CT.ColorTheme.homeText,
                                    //           fontFamily: "TitilliumWebBold",
                                    //         ),
                                    //         children: <TextSpan>[
                                    //           TextSpan(
                                    //             text: "0.00 ",
                                    //           ),
                                    //           TextSpan(
                                    //             text: "LKR",
                                    //             style: TextStyle(
                                    //                 fontSize: 18,
                                    //                 fontWeight: FontWeight.bold,
                                    //                 color:
                                    //                     CT.ColorTheme.homeText),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // TableRow(
                                    //   children: <Widget>[
                                    //     Text(
                                    //       "Battery",
                                    //       style: TextStyle(
                                    //         fontSize: 20,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       "${snapshot.data.documents[0]["batteryLevel"]} %",
                                    //       style: TextStyle(
                                    //         fontSize: 22,
                                    //         color: CT.ColorTheme.homeText,
                                    //         fontFamily: "TitilliumWebBold",
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // TableRow(
                                    //   children: <Widget>[
                                    //     Text(
                                    //       "Credit",
                                    //       style: TextStyle(
                                    //         fontSize: 20,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //     RichText(
                                    //       text: TextSpan(
                                    //         style: TextStyle(
                                    //           fontSize: 22,
                                    //           color: CT.ColorTheme.homeText,
                                    //           fontFamily: "TitilliumWebBold",
                                    //         ),
                                    //         children: <TextSpan>[
                                    //           TextSpan(text: widget.credit),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
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
                        margin: EdgeInsets.only(top: 260.0),
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
                    Visibility(
                      visible: !isTripStarted,
                      child: Container(
                        margin: EdgeInsets.only(top: 340.0),
                        child: SizedBox(
                          width: 175,
                          height: 60,
                          child: RaisedButton(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27.0)),
                            elevation: 8,
                            highlightElevation: 2,
                            splashColor: Colors.white54,
                            onPressed: () => _cancelPressed(),
                            child: Text(
                              "Cancel",
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
                    Visibility(
                      visible: false,
                      child: Container(
                        margin: EdgeInsets.only(top: 320.0),
                        child: SizedBox(
                          width: 175,
                          height: 60,
                          child: RaisedButton(
                            color: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27.0)),
                            elevation: 8,
                            highlightElevation: 2,
                            splashColor: Colors.white54,
                            onPressed: () => _finishTrip(),
                            child: Text(
                              "Finish Trip",
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

  _cancelPressed() {
    _finishTrip();
  }

  _goBackToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => new HomeScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  _lockUnlockBike(bool locked) {
    var docRef =
        Firestore.instance.collection("bicycles").document(widget.bikeId);

    Firestore.instance.runTransaction((transaction) async {
      await transaction
          .update(docRef, {"unlocking": true}).then((data) async {
        lockRequestSent = true;
        isTripStarted = false;
        isButtonVisible = false;
        setState(() {});
      });
    });
  }

  _finishTrip() {
    var docRef =
        Firestore.instance.collection("bicycles").document(widget.bikeId);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(docRef, {"availability": true});
    }).then((onValue){
      _goBackToHome();
    });
  }
}
