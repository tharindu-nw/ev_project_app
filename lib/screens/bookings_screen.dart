import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();

  final bool onTrip;
  final String bikeId;

  BookingScreen({@required this.onTrip, @required this.bikeId})
      : assert(bikeId != null),
        assert(onTrip != null);
}

class _BookingScreenState extends State<BookingScreen> {
  var bike;
  var _fare;

  var lockRequestSent = false;
  var isButtonVisible = true;
  var isTripStarted = false;
  var isTripFinished = false;
  var isFareReceived = false;

  var startTimeReceived;

  var _startTime = "-- : -- : --";
  var _endTime;
  DateTime _startTimeStamp;
  DateTime _endTimeStamp;
  var _duration;
  var _tripId;

  var cardHeight = 380;

  @override
  void initState() {
    super.initState();
    if (widget.onTrip) {
      _getCurrentTripDetails();
    }
  }

  _getBikeDetails() async {
    var availableQuery =
        Firestore.instance.collection("bicycles").document(widget.bikeId);

    return await availableQuery.get();
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
              return false;
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
                child: widget.onTrip
                    ? _buildLoading()
                    : (lockRequestSent ? _buildLoading() : _buildBookings()),
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
                    .document(widget.bikeId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text("Loading...");
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = snapshot.data;
                      if (doc['locked'] == true &&
                          doc['unlocking'] == true &&
                          doc['secretKey'] == null) {
                        return Center(
                          child: SpinKitCubeGrid(
                            color: CT.ColorTheme.homeText,
                            size: 50.0,
                          ),
                        );
                      }
                      if (doc['locked'] == true &&
                          doc['unlocking'] == false &&
                          doc['unlockingError'] == true) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Sorry, Something went wrong!",
                              style: TextStyle(
                                color: CT.ColorTheme.homeText,
                                fontFamily: "NunitoRegular",
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 60.0),
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 175,
                                height: 60,
                                child: RaisedButton(
                                  color: CT.ColorTheme.loginGradientStart,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(27.0)),
                                  elevation: 8,
                                  highlightElevation: 2,
                                  splashColor: Colors.white54,
                                  onPressed: () => _finishTrip(),
                                  child: Text(
                                    "Go Back",
                                    style: TextStyle(
                                      fontFamily: "TitilliumWebBold",
                                      color: Colors.white,
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (doc['locked'] == true &&
                          doc['unlocking'] == true &&
                          doc['secretKey'] != null) {
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
                              "${doc["bicycleName"]}",
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
                              "${doc["secretKey"]}",
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
                      } else if (doc['locked'] == false &&
                          doc['unlocking'] == false &&
                          !widget.onTrip) {
                        isTripStarted = true;
                        _startTime = DateFormat.jm().format(new DateTime.now());
                        _startTimeStamp = DateTime.now();
                        _tripId = doc['currentTripId'];
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
                              "${doc["bicycleName"]}",
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
                                        _startTime,
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
                              style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 24,
                                  color: CT.ColorTheme.loginGradientStart),
                            ),
                            Text(
                              "Lock the bike into the station at the end of your trip to finish",
                              style: TextStyle(
                                fontFamily: "TitilliumWebBold",
                                fontSize: 20,
                              ),
                            ),
                          ],
                        );
                      } else if (doc['locked'] == false &&
                          doc['unlocking'] == false &&
                          widget.onTrip &&
                          startTimeReceived != null &&
                          !startTimeReceived) {
                        isTripStarted = true;
                        return Center(
                          child: SpinKitCubeGrid(
                            color: CT.ColorTheme.homeText,
                            size: 50.0,
                          ),
                        );
                      } else if (doc['locked'] == false &&
                          doc['unlocking'] == false &&
                          widget.onTrip &&
                          startTimeReceived != null &&
                          startTimeReceived) {
                        isTripStarted = true;
                        _tripId = doc['currentTripId'];
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
                              "${doc["bicycleName"]}",
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
                                        _startTime,
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
                              style: TextStyle(
                                  fontFamily: "TitilliumWebBold",
                                  fontSize: 24,
                                  color: CT.ColorTheme.loginGradientStart),
                            ),
                            Text(
                              "Lock the bike into the station at the end of your trip to finish",
                              style: TextStyle(
                                fontFamily: "TitilliumWebBold",
                                fontSize: 20,
                              ),
                            ),
                          ],
                        );
                      } else if (doc['locked'] == true &&
                          doc['unlocking'] == false &&
                          isTripStarted &&
                          !isFareReceived) {
                        _endTimeStamp = DateTime.now();
                        _endTime = DateFormat.jm().format(_endTimeStamp);
                        _requestFare();
                        _duration =
                            _endTimeStamp.difference(_startTimeStamp).inMinutes;
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
                                        _startTime,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "TitilliumWebBold",
                                            color: CT.ColorTheme.homeText),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Text(
                                        "End time",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _endTime,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "TitilliumWebBold",
                                            color: CT.ColorTheme.homeText),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Text(
                                        "Duration",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "$_duration Min",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "TitilliumWebBold",
                                            color: CT.ColorTheme.homeText),
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
                                      Text(
                                        "Receiving...",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "TitilliumWebBold",
                                            color: CT
                                                .ColorTheme.bookingGradientEnd),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isTripFinished,
                              child: Container(
                                margin: EdgeInsets.only(top: 20.0),
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 175,
                                  height: 60,
                                  child: RaisedButton(
                                    color: CT.ColorTheme.loginGradientStart,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(27.0)),
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
                      } else if (doc['locked'] == true &&
                          doc['unlocking'] == false &&
                          isTripFinished &&
                          isFareReceived) {
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
                                        _startTime,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "TitilliumWebBold",
                                            color: CT.ColorTheme.homeText),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Text(
                                        "End time",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _endTime,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "TitilliumWebBold",
                                            color: CT.ColorTheme.homeText),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Text(
                                        "Duration",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "$_duration Min",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "TitilliumWebBold",
                                            color: CT.ColorTheme.homeText),
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
                                      Text(
                                        _fare == "Error"
                                            ? "Error"
                                            : "${_fare.toStringAsFixed(2)}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "TitilliumWebBold",
                                            color: CT
                                                .ColorTheme.bookingGradientEnd),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isTripFinished,
                              child: Container(
                                margin: EdgeInsets.only(top: 20.0),
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 175,
                                  height: 60,
                                  child: RaisedButton(
                                    color: CT.ColorTheme.loginGradientStart,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(27.0)),
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
                        return Center(
                          child: SpinKitCubeGrid(
                            color: CT.ColorTheme.homeText,
                            size: 50.0,
                          ),
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
                                "${snapshot.data["bicycleName"]}",
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
                                          _startTime,
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
                return Center(
                  child: SpinKitCubeGrid(
                    color: CT.ColorTheme.homeText,
                    size: 50.0,
                  ),
                );
              }
            case ConnectionState.active:
              {
                return Center(
                  child: SpinKitCubeGrid(
                    color: CT.ColorTheme.homeText,
                    size: 50.0,
                  ),
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
                          _goBackToHome();
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

  _goBackToHome() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => new HomeScreen(
            uId: user.uid,
          ),
        ),
        (Route<dynamic> route) => false);
  }

  _getCurrentTripDetails() async {
    startTimeReceived = false;
    final bikeQuery =
        Firestore.instance.collection("bicycles").document(widget.bikeId);
    bikeQuery.get().then((DocumentSnapshot snap) {
      if (snap.data.isNotEmpty) {
        var tripId = snap.data["currentTripId"];
        final tripQuery =
            Firestore.instance.collection("trips").document(tripId);
        tripQuery.get().then((DocumentSnapshot snap2) {
          if (snap2.data.isNotEmpty) {
            var timeEpoch = snap2.data['startTime'];
            _startTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeEpoch);
            _startTime = DateFormat.jm().format(_startTimeStamp);
            startTimeReceived = true;
            setState(() {});
          }
        });
      }
    });
  }

  _lockUnlockBike(bool locked) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userId = user.uid;

    var docRef =
        Firestore.instance.collection("bicycles").document(widget.bikeId);

    Firestore.instance.runTransaction((transaction) async {
      await transaction
          .update(docRef, {"unlocking": true, "currentUserId": userId}).then(
              (data) async {
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
    }).then((onValue) {
      _goBackToHome();
    });
  }

  _requestFare() async {
    final url =
        "https://us-central1-ev-firestore-2019.cloudfunctions.net/getTrip?tripId=$_tripId";

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      _fare = result['tripCost'];
      isFareReceived = true;
      setState(() {});
    } else {
      _fare = "Error";
      isFareReceived = true;
      setState(() {});
    }
  }
}
