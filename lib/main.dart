import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taamin/repository/authpage_repository.dart';
import 'package:taamin/repository/user_repository.dart';
import 'package:taamin/routes.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  File file = File('${document.path}/boarding.txt');
  bool boarding;
  try {
    boarding = int.parse(await file.readAsString()) == 1;
  } catch (err) {
    boarding = true;
  }

  Routes.createRoutes();
  runApp(MyApp(boarding));
}

class MyApp extends StatelessWidget {
  final bool boarding;
  MyApp(this.boarding);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserRepository.instance(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthPageRepository.instance(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: boarding ? 'boarding' : '/',
        onGenerateRoute: Routes.sailor.generator(),
        navigatorKey: Routes.sailor.navigatorKey,
        theme: ThemeData(
          primaryColorDark: Color(0xFFf85f6a),
          primaryColor: Color(0xFFf85f6a),
          primaryColorLight: Color(0xFFf85f6a).withOpacity(0.8),
          accentColor: Colors.white,
          buttonColor: Color(0xFFfbb849),
          cursorColor: Colors.yellow[900],
        ),
      ),
    );
  }
}
