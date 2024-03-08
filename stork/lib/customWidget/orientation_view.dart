import 'package:flutter/material.dart';

class OrientationView extends StatelessWidget {
  final Widget landscapeView;
  final Widget portraitView;

  const OrientationView({Key key, this.landscapeView, @required this.portraitView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return isLandscape && landscapeView != null
        ? landscapeView
        : portraitView;
  }
}