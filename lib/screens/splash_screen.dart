import 'package:flutter/material.dart';
import 'package:taamin/components/loading_widget.dart';
import 'package:taamin/repository/info_repository.dart';
import 'package:taamin/repository/offers_repository.dart';
import 'package:taamin/repository/pages_repository.dart';
import 'package:taamin/screens/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:taamin/repository/user_repository.dart';
import 'package:taamin/repository/authpage_repository.dart';
import 'package:taamin/screens/pages/pages.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(
      builder: (context, user, child) {
        print(user.status);
        switch (user.status) {
          case Status.Uninitialized:
            return Scaffold(body: LoadingWidget());
            break;
          case Status.Unauthenticated:
          case Status.Registering:
          case Status.Authenticating:
            return ChangeNotifierProvider(
                create: (_) => AuthPageRepository.instance(), child: Auth());
            break;
          case Status.Authenticated:
            return MultiProvider(providers: [
              ChangeNotifierProvider(
                create: (_) => PagesRepository.instance(),
              ),
              ChangeNotifierProvider(
                create: (_) => OffersRepository.instance(),
              ),
              ChangeNotifierProvider(
                create: (_) => InfoRepository.instance(),
              )
            ], child: Pages(user.user.uid,user.user.email));
            break;
          default:
            return LoadingWidget();
        }
      },
    );
  }
}
