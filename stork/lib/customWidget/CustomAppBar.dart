import 'package:flutter/material.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Widget title;
  final bool centerTitle;
  final Widget leading;
  final double leadingWidth;
  final List<Widget> actions;
  final Widget bottom;

  const CustomAppBar(
      {Key key,
      @required this.title,
      this.centerTitle,
      this.leading,
      this.leadingWidth,
      this.actions,
      this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: centerTitle ?? false,
      leading: leading,
      leadingWidth: leadingWidth,
      actions: actions ?? List.empty(),
      flexibleSpace: appbarGradient(),
      bottom: bottom
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;

}
