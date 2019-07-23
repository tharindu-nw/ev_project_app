import 'package:flutter/material.dart';
import 'package:ev_app/style/color_theme.dart' as CT;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ev_app/utils/bubble_indication_painter.dart';
import 'package:flutter/services.dart';

final _padding = EdgeInsets.only(top: 20.0);
final _bigPadding = EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0);

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: CT.ColorTheme.gradient,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: _bigPadding,
                      child: new Image(
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.fill,
                        image: new AssetImage('assets/img/bicycle_icon.png'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: _buildMenuBar(context),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 1) {
                            setState(() {
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      // padding: _padding,
      child: Column(
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  width: 300,
                  height: 190,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                          left: 25.0,
                          right: 25.0,
                        ),
                        child: TextField(
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontFamily: "TitilliumWebBold",
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                              fontFamily: "TitilliumWebBold",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                          left: 25.0,
                          right: 25.0,
                        ),
                        child: TextField(
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                            fontFamily: "TitilliumWebBold",
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontFamily: "TitilliumWebBold",
                              fontSize: 16,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 210.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: CT.ColorTheme.gradient,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CT.ColorTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CT.ColorTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CT.ColorTheme.loginGradientStart,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        fontFamily: "TitilliumWebBold",
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    print("Login was pressed");
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  fontFamily: "TitilliumWebReg",
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 1.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        Colors.white10,
                        Colors.white,
                      ],
                      stops: [0.0, 1.0],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                      fontFamily: "TitilliumWebBold",
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white10,
                      ],
                      stops: [0.0, 1.0],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 23.0, 0, 15.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 320.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeName,
                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "Name",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "TitilliumWebBold",
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmail,
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "TitilliumWebBold",
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePassword,
                          controller: signupPasswordController,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "TitilliumWebBold",
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignup,
                              child: Icon(
                                _obscureTextSignup
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                        child: TextField(
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "TitilliumWebBold",
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignupConfirm,
                              child: Icon(
                                _obscureTextSignupConfirm
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 310.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CT.ColorTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CT.ColorTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        CT.ColorTheme.loginGradientStart,
                        CT.ColorTheme.loginGradientEnd,
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: CT.ColorTheme.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "TitilliumWebBold",
                        ),
                      ),
                    ),
                    onPressed: () {}
                    // showInSnackBar("SignUp button pressed")),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                    fontFamily: "TitilliumWebBold",
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                    fontFamily: "TitilliumWebBold",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
