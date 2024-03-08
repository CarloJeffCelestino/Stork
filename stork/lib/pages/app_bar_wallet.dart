import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:nopcart_flutter/pages/account/cart/shopping_cart_screen.dart';
import 'package:nopcart_flutter/pages/account/rewardPoint/reward_point_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/nop_cart_icons.dart';

class AppBarWallet extends StatefulWidget {

  final Color color;

  const AppBarWallet({Key key, this.color}) : super(key: key);

  @override
  _AppBarWalletState createState() => _AppBarWalletState();
}

class _AppBarWalletState extends State<AppBarWallet> {
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
              Navigator.of(context).pushNamed(RewardPointScreen.routeName);
            },
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: widget.color ?? Colors.black,
            ),
          ),
        );
      },
    );
  }
}
