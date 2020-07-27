import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;


  Future<FirebaseUser> signInWithGoogle() async {
    var googleAccount;
    try {
      googleAccount = await _googleSignIn.signIn();
    } catch (error) {
      print(error.code);
    }

    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return authResult.user;
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      final authResult = await _auth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      return authResult.user;
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection("users").document(user.uid);

    return ref.setData({
      'email': user.email,
      'name': user.displayName,
      'photoUrl': user.photoUrl,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  void signOut() {
    _auth.signOut();
  }
}
