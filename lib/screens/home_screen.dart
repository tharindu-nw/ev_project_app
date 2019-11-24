import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/stations_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController _pc = new PanelController();
  var myBike = null;
  var _auth = FirebaseAuth.instance;
  var _credit = "";


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
                      future: _getUserName(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            {
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
                                  (snapshot.data != null)
                                  ?
                                  Text(
                                    "${snapshot.data}",
                                    style: TextStyle(
                                      color: CT.ColorTheme.homeText,
                                      fontFamily: "NunitoRegular",
                                      fontSize: 37,
                                    ),
                                  ) : Text(
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
                    )
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
                      onPressed: () => _openStationsScreen(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                    child: FutureBuilder(
                      future: _getUserData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            {
                              return (snapshot.data.documents.isNotEmpty)
                                  ? Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Trips : ${snapshot.data.documents[0].data["trips"].toString()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "NunitoRegular",
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    "Credit :  ${snapshot.data.documents[0].data["amount"].toString()}",
                                    style: TextStyle(
                                      color: CT.ColorTheme.homeText,
                                      fontFamily: "NunitoRegular",
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ) : Container();
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

  Future<String> _getUserName() async {
    FirebaseUser user = await _auth.currentUser();
    return user.displayName;
  }

  Future<QuerySnapshot> _getUserData()async {
    FirebaseUser user = await _auth.currentUser();
    var userQuery = Firestore.instance
        .collection("users")
        .where("email", isEqualTo: user.email);

    userQuery.getDocuments().then((QuerySnapshot snapshot) {
      if(snapshot.documents.isNotEmpty){
        var user = snapshot.documents[0];
        _credit = user.data["amount"].toString();
      }
    });

    return await userQuery.getDocuments();
  }

  _logout() {
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false);
  }

  _openStationsScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new StationsScreen(credit: _credit),
      ),
    );
  }

}
