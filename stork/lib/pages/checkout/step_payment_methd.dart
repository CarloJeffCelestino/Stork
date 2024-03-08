import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/checkout_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/model/SaveBillingResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:nopcart_flutter/utils/extensions.dart';

class StepPaymentMethod extends StatefulWidget {
  final CheckoutBloc bloc;
  final PaymentMethodModel paymentMethodModel;

  StepPaymentMethod(this.bloc, {this.paymentMethodModel});

  @override
  _StepPaymentMethodState createState() {
    bloc.selectedPaymentMethod = paymentMethodModel?.paymentMethods?.safeFirstWhere(
      (element) => element.selected == true,
      orElse: () {
        return paymentMethodModel?.paymentMethods?.safeFirst();
      },
    );
    bloc.userRewardPoint = paymentMethodModel?.useRewardPoints ?? false;

    return _StepPaymentMethodState(this.bloc,
        paymentMethodModel: this.paymentMethodModel);
  }
}

class _StepPaymentMethodState extends State<StepPaymentMethod> {
  final CheckoutBloc bloc;
  final PaymentMethodModel paymentMethodModel;
  GlobalService _global = GlobalService();

  _StepPaymentMethodState(this.bloc, {this.paymentMethodModel});

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration.zero, () {
      bloc.selectedPaymentMethod =  bloc.selectedPaymentMethod ?? paymentMethodModel.paymentMethods.first;
      bloc.savePaymentMethod();
    });

    return Visibility(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: paymentMethodModel?.paymentMethods?.isNotEmpty == true
            ? Column(
          children: [
            if (paymentMethodModel.displayRewardPoints)
              CheckboxListTile(
                value: bloc.userRewardPoint,
                title: Text(GlobalService()
                    .getString(Const.USE_REWARD_POINTS)
                    .replaceFirst(
                    '{0}',
                    paymentMethodModel.rewardPointsBalance
                        ?.toString() ??
                        '0')
                    .replaceFirst('{1}',
                    paymentMethodModel?.rewardPointsAmount ?? '0')),
                onChanged: (value) {
                  setState(() {
                    bloc.userRewardPoint = value;
                  });
                },
              ),
            if (paymentMethodModel.useRewardPoints) getDivider(),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: paymentMethodModel.paymentMethods.length,
              itemBuilder: (context, index) {
                var method = paymentMethodModel.paymentMethods[index];
                var fee =
                method.fee?.isNotEmpty == true ? '(${method.fee})' : '';
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: method == bloc.selectedPaymentMethod
                            ? isDarkThemeEnabled(context)
                            ? Colors.grey[700]
                            : Colors.grey[300]
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      selected: method == bloc.selectedPaymentMethod,
                      onTap: () {
                        setState(() {
                          bloc.selectedPaymentMethod = method;
                        });
                      },
                      leading: CpImage(
                        url: method.logoUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.fitWidth,
                      ),
                      title: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text('${method.name} $fee')),
                      subtitle: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(
                            method.description ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: _global
                        .getString(Const.CONTINUE)
                        .toUpperCase(),
                    onClick: () {
                      bloc.savePaymentMethod();
                    },
                  ),
                )
              ],
            ),
          ],
        )
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_global.getString(Const.COMMON_NO_DATA)),
        ),
      ),
      visible: false,
    );
  }
}
