import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/bookings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ev_app/widgets/cards/easyBadgeCard.dart';
import 'package:ev_app/utils/mock_data.dart';
import 'package:ev_app/widgets/navigation/navbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _cIndex = 0;
  PanelController _pc = new PanelController();
  var myBike = null;

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
      child: _buildAvailableScreen(),
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
            onPressed: () => {print(MediaQuery.of(context).size.height)},
          ),
        ),
      ],
    );
  }

  Widget _buildCycleList() {
    return StreamBuilder(
      stream: Firestore.instance.collection("bicycles").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading...");
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = snapshot.data.documents[index];
            return EasyBadgeCard(
              leftBadge: Colors.white,
              prefixIcon: FontAwesomeIcons.bicycle,
              prefixIconColor: Color(0xFF160F29),
              backgroundColor: CT.ColorTheme.cardBackground,
              title: "Bike ${index + 1}",
              description: 'Rating: ${doc['rating']}',
              titleColor: Color(0xFF160F29),
              descriptionColor: Color(0xFF160F29),
              suffixIcon: Icons.arrow_forward_ios,
              suffixIconColor: Color(0xFF160F29),
            );
          },
        );
      },
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
                          "available",
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
                    width: MediaQuery.of(context).size.width * 0.58,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "NunitoRegular",
                          fontSize: 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: "There are "),
                          TextSpan(
                            text: "5",
                            style: TextStyle(
                              color: CT.ColorTheme.homeText,
                              fontFamily: "NunitoRegular",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                              text:
                                  " bikes available at the dock right now. Click below to start your journey"),
                        ],
                      ),
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
      bottomNavigationBar: Navbar(
        currentIndex: 0,
      ),
    );
  }

  _logout() {
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false);
  }

  _bookNow() async {
    var availableQuery = Firestore.instance
        .collection("bicycles")
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
              builder: (context) => new BookingScreen(myBike: myBike),
            ),
            (Route<dynamic> route) => false);
      }
    });
  }
}
