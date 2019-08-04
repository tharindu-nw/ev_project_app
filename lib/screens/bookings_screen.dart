import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:ev_app/utils/mock_data.dart';
import 'package:ev_app/widgets/navigation/navbar.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  var _cIndex = 1;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: CT.ColorTheme.loginGradient,
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildAppbar(),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: _buildBookings(),
                ),
              ],
            ),
            bottomNavigationBar: Navbar(
              currentIndex: 1,
            )),
      ),
    );
  }

  Widget _buildBookings() {
    return ListView.builder(
        itemCount: mockData.bookings.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 10.0,
                  color: CT.ColorTheme.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Container(
                    width: 300,
                    height: 290,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              mockData.bookings[index][0],
                              style: Theme.of(context).textTheme.display1.apply(
                                    fontWeightDelta: 600,
                                    color: Colors.black,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Table(
                              defaultColumnWidth: FlexColumnWidth(1.0),
                              columnWidths: {1: FractionColumnWidth(0.2)},
                              children: <TableRow>[
                                TableRow(
                                  children: <Widget>[
                                    Text(
                                      "Duration",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      ":",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "1 hr 30 min",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: <Widget>[
                                    Text(
                                      "Starting at",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      ":",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "14 : 30",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: <Widget>[
                                    Text(
                                      "Status",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      ":",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Available",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 210.0, left: 75.0),
                          child: FloatingActionButton(
                            heroTag: "Edit${index}",
                            child: Icon(Icons.edit),
                            backgroundColor: Colors.blue,
                            onPressed: _onPressed(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 210.0),
                          child: FloatingActionButton(
                            heroTag: "Delete${index}",
                            child: Icon(Icons.delete),
                            backgroundColor: Colors.red,
                            onPressed: _onPressed(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 210.0, right: 75.0),
                          child: FloatingActionButton(
                            heroTag: "Unlock${index}",
                            child: Icon(Icons.lock_open),
                            backgroundColor: Colors.green,
                            onPressed: _onPressed(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        "My Bookings",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 30.0,
        ),
      ),
    );
  }

  _onPressed() {}
}
