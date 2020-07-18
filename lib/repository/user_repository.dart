import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:taamin/services/database_service.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Registering,
  Unauthenticated
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (err) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInUsingGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      await FirebaseAuth.instance.signInWithCredential(credential);

      await DatabaseService.initial(user.uid, user.email);
      return true;
    } catch (err) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print('GOOGLE SIGN IN ERROR $err');
      return false;
    }
  }

  Future<bool> signInUsingFacebook() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      var facebookLogin = FacebookLogin();
      var result = await facebookLogin.logIn(['email', 'public_profile']);

      FacebookAccessToken myToken = result.accessToken;
      AuthCredential credential =
          FacebookAuthProvider.getCredential(accessToken: myToken.token);
      await _auth.signInWithCredential(credential);

      await DatabaseService.initial(user.uid, user.email);

      return true;
    } catch (err) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print('FACEBOOK SIGN IN ERROR $err');
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    _status = Status.Registering;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (err) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
