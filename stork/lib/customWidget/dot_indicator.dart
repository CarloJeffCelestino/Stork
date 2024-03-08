import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DotIndicator extends StatelessWidget {
  final int dotsCount;
  final int selectedIndex;

  DotIndicator({Key key, this.dotsCount, this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [for (var i = 0; i < dotsCount; i += 1) i].map((index) {
        return Container(
          width: 9.0,
          height: 9.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
              width: 1.0,
            ),
            color: selectedIndex == index
                ? Theme.of(context).primaryColor
                : Colors.grey[400],
          ),
        );
      }).toList(),
    );
  }
}
