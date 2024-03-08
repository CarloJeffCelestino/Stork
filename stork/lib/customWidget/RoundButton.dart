import 'package:flutter/material.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class RoundButton extends StatelessWidget {
  final double radius;
  final Icon icon;
  final Function onClick;

  const RoundButton(
      {Key key,
      @required this.radius,
      @required this.icon,
      @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkThemeEnabled(context) ? Color(0xFF4C4A4A) : Color(0xFFF6F6FA),
          boxShadow: [
            BoxShadow(
              color: isDarkThemeEnabled(context) ? Color(0xFF3D3C3C) : Colors.grey[300],
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(1.5, 1.5), // shadow direction: bottom right
            )
          ],
        ),
        child: icon,
      ),
    );
  }
}
