import 'package:flutter/material.dart';

class ScrollViewWithScrollBar extends StatefulWidget {
  final Widget child;
  const ScrollViewWithScrollBar({Key key, @required this.child}) : super(key: key);

  @override
  _ScrollViewWithScrollBarState createState() => _ScrollViewWithScrollBarState();
}

class _ScrollViewWithScrollBarState extends State<ScrollViewWithScrollBar> {
  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: Theme.of(context).primaryColor,
      radius: Radius.circular(20),
      thickness: 3.0,
      isAlwaysShown: true,
      child: SingleChildScrollView(
        child: widget.child,
      ),
    );
  }
}
