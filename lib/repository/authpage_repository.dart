import 'package:flutter/foundation.dart';

enum AuthPageSelect { SignIn, SignUp }

class AuthPageRepository with ChangeNotifier {
  AuthPageSelect _authPage;
  AuthPageSelect get authPageSelect => _authPage;

  AuthPageRepository.instance() {
    _authPage = AuthPageSelect.SignIn;
  }

  changeToSignIn() {
    _authPage = AuthPageSelect.SignIn;
    notifyListeners();
  }

  changeToSignUp() {
    _authPage = AuthPageSelect.SignUp;
    notifyListeners();
  }
}
