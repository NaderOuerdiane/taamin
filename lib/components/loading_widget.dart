import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: Theme.of(context).primaryColor,
      size: 30,
      lineWidth: 5,
    );
  }
}
