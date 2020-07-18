import 'package:flutter/material.dart';
import 'package:taamin/screens/auth/signin.dart';
import 'package:taamin/screens/auth/signup.dart';
import 'package:taamin/repository/authpage_repository.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPageRepository>(
      builder: (context, auth, child) {
        switch (auth.authPageSelect) {
          case AuthPageSelect.SignIn:
            return SignInPage();
            break;
          case AuthPageSelect.SignUp:
            return SignUpPage();
            break;
          default:
            return SignInPage();
        }
      },
    );
  }
}
