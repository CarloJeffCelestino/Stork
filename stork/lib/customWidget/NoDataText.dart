import 'package:flutter/material.dart';

class NoDataText extends StatelessWidget {
  final String msg;
  NoDataText(this.msg, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(msg, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
