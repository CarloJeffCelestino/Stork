import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/model/home/ManufacturersResponse.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';

class RewardPointHeader extends StatelessWidget {

  final num rewardPointsBalance;

  RewardPointHeader(this.rewardPointsBalance);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${rewardPointsBalance ?? 0}',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    )
                  ),
                  TextSpan(
                    text: '\nTotal Storkbucks',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )
                  ),
                  TextSpan(
                    text: '\n\nEarn Storkbucks in every purchase.\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    )
                  ),
                ]
            )
            // displayMsg,
            // style: Theme.of(context).textTheme.subtitle1.copyWith(
            //   fontSize: 16,
          ),
        ),
      ),
    );
  }
}
