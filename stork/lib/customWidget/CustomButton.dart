import 'package:flutter/material.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onClick;
  final ButtonShape shape;
  final Color backgroundColor;
  final bool enabled;

  const CustomButton(
      {Key key,
      @required this.label,
      @required this.onClick,
      this.shape,
      this.backgroundColor,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    var btnRadius;

    if(shape == null || shape == ButtonShape.Rounded) {
      btnRadius = BorderRadius.circular(24);
    } else if (shape == ButtonShape.RoundedTop) {
      btnRadius = BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      );
    } else if (shape == ButtonShape.RoundedTopLeft) {
      btnRadius = BorderRadius.only(
        topLeft: Radius.circular(18),
      );
    } else if (shape == ButtonShape.RoundedTopRight) {
      btnRadius = BorderRadius.only(
        topRight: Radius.circular(18),
      );
    }

    GlobalService _globalService = GlobalService();

    return ElevatedButton(
      onPressed: () => enabled ? onClick() : null,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        //backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: btnRadius,
        ),
        tapTargetSize: shape == ButtonShape.RoundedTop
            ? MaterialTapTargetSize.shrinkWrap
            : null,
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: btnRadius,
          gradient: _globalService.getAppLandingData().gradientEnabled && backgroundColor==null
              ? getGradient(_globalService)
              : null,
          color: enabled ? backgroundColor ?? Theme.of(context).primaryColor : Colors.grey,
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: 50, maxHeight: 50),
          alignment: Alignment.center,
          child: Text(
            label,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
