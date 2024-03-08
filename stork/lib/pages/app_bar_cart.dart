import 'dart:ui';

import 'package:badges/badges.dart' as customBadge;
import 'package:flutter/material.dart';
import 'package:nopcart_flutter/pages/account/cart/shopping_cart_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/nop_cart_icons.dart';

class AppBarCart extends StatefulWidget {

  final Color color;

  const AppBarCart({Key key, this.color}) : super(key: key);

  @override
  _AppBarCartState createState() => _AppBarCartState();
}

class _AppBarCartState extends State<AppBarCart> {
  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return StreamBuilder<int>(
      initialData: GlobalService().getCartCount,
      stream: GlobalService().cartCountStream,
      builder: (context, snapshot) {
        return Padding(
          padding: isRtl ? EdgeInsets.fromLTRB(20, 0, 20, 0) : EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
            },
            child: customBadge.Badge(
              position: customBadge.BadgePosition.topEnd(top: 4, end: -15),
              badgeContent: Text(
                (snapshot?.data ?? 0).toString(),
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).appBarTheme.titleTextStyle.color),
              ),
              badgeColor: Theme.of(context).primaryColor,
              child: Icon(
                  Icons.shopping_bag_outlined,
                  color: widget.color ?? Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
