import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:nopcart_flutter/model/RewardPointResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ItemRewardPoint extends StatelessWidget {
  final RewardPoint item;
  final GlobalService _globalService = GlobalService();
  final dateTimeFormat = 'MM/dd/yy hh:mm';

  ItemRewardPoint({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var textStyle = Theme.of(context).textTheme.subtitle1.copyWith(
      fontSize: 14.5,
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: Row(
          children: [
            RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: '${item.pointsBalance}',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )
                      ),
                      TextSpan(
                          text: ' Storkbucks',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )
                      ),
                      TextSpan(
                          text: '\n${item.createdOn}',
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

            Spacer(),

            Text(
                '${item.points >= 0 ? '+' : '-'} ${item.points.abs()}',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )
            )
          ],
        )
        // Table(
        //   children: [
        //     TableRow( children: [
        //       Text(_globalService.getString(Const.REWARD_POINT_DATE), style: textStyle),
        //       Text(getFormattedDate(item.createdOn, format: dateTimeFormat), style: textStyle),
        //     ]),
        //     TableRow( children: [
        //       Text(_globalService.getString(Const.REWARD_POINT_), style: textStyle),
        //       Text(item.points?.toString() ?? '', style: textStyle),
        //     ]),
        //     TableRow( children: [
        //       Text(_globalService.getString(Const.REWARD_POINT_BALANCE), style: textStyle),
        //       Text(item.pointsBalance ?? '', style: textStyle),
        //     ]),
        //     TableRow( children: [
        //       Text(_globalService.getString(Const.REWARD_POINT_MSG), style: textStyle),
        //       Text(item.message ?? '', style: textStyle),
        //     ]),
        //     TableRow( children: [
        //       Text(_globalService.getString(Const.REWARD_POINT_END_DATE), style: textStyle),
        //       Text(getFormattedDate(item.endDate, format: dateTimeFormat), style: textStyle),
        //     ]),
        //   ],
        // ),
      ),
    );

  }
}
