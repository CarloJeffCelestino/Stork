
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nopcart_flutter/bloc/checkout_bloc.dart';
import 'package:nopcart_flutter/customWidget/order_total_table.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/ProductDetailsResponse.dart';
import 'package:nopcart_flutter/model/SaveBillingResponse.dart';
import 'package:nopcart_flutter/pages/account/cart/CartListItem.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nopcart_flutter/bloc/address_bloc.dart';

import '../account/address/add_edit_address_screen.dart';


class StepConfirmOrder extends StatefulWidget {
  final CheckoutBloc bloc;
  final ConfirmModel confirmModel;
  final PaymentMethodModel paymentMethodModel;
  final PaymentInfoModel paymentInfoModel;
  final GetBillingData getBillingData;
  final ProductPrice productPrice;

  final CheckoutPostResponseData checkoutPostResponseData;


  StepConfirmOrder(this.bloc, {
    this.confirmModel,
    this.paymentMethodModel,
    this.paymentInfoModel,
    this.getBillingData,
    this.productPrice,


    this.checkoutPostResponseData,

  });

  @override
  _StepConfirmOrderState createState() =>
      _StepConfirmOrderState(this.bloc, confirmModel: this.confirmModel, paymentMethodModel: this.paymentMethodModel,paymentInfoModel: this.paymentInfoModel,getBillingData: this.getBillingData,    checkoutPostResponseData: this.checkoutPostResponseData, productPrice: this.productPrice);
}

class _StepConfirmOrderState extends State<StepConfirmOrder> {
  final CheckoutBloc bloc;
  final ConfirmModel confirmModel;
  final PaymentMethodModel paymentMethodModel;
  final PaymentInfoModel paymentInfoModel;
  final GetBillingData getBillingData;
  final CheckoutPostResponseData checkoutPostResponseData;
  final ProductPrice productPrice;
  GlobalService _globalService = GlobalService();
  AddressBloc _bloc;
  _StepConfirmOrderState(this.bloc, {this.confirmModel, this.paymentMethodModel,this.paymentInfoModel, this.getBillingData,  this.checkoutPostResponseData, this.productPrice});



  @override
  void initState() {
    super.initState();
    super.initState();
    _bloc = AddressBloc();
    _bloc.fetchAddressList();
    // bloc.fetchBillingAddress();
    // bloc.getBillingStream.listen((event) {
    //   switch (event.status) {
    //     case Status.COMPLETED:
    //       setState(() {
    //         billingData = event.data.data;
    //       });
    //       break;
    //   }
    // });?
  }

  @override
  Widget build(BuildContext context) {

    var btnNewAddress = ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed(
        AddOrEditAddressScreen.routeName,
        arguments: AddOrEditAddressScreenArgs(isEditMode: false, addressId: -1),
      ).then((value) => setState(() {
        _bloc.fetchAddressList();
      })),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(10, 30),
      ),
      child: Text(_globalService.getString(Const.ADD_NEW_ADDRESS).toUpperCase()),
    );




    var billingAdrsCard = GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext bc) {
            return Container(
              height: MediaQuery.of(context).size.height - 80,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: getBillingData.billingAddress.existingAddresses.toList().map((e) {
                          return ListTile(
                            title: Text(e.address1),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              setState(() {
                                bloc.storePickup = false;
                                bloc.selectedExistingBillingAddress = e;
                                bloc.saveBillingAddress(newAddress: false);
                                Navigator.of(context).pop();
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // btnNewAddress,

                ],
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 12,
            bottom: 12,
            top: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      'Billing Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 32,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${confirmModel.cart.orderReviewData.billingAddress.firstName} ${confirmModel.cart.orderReviewData.billingAddress.lastName}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${confirmModel.cart.orderReviewData.billingAddress.address1} ${confirmModel.cart.orderReviewData.billingAddress.stateProvinceName} ${confirmModel.cart.orderReviewData.billingAddress.zipPostalCode}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(
                Icons.edit_outlined,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );






    var shippingAdrsCard = GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext bc) {
              return Container(
                height: MediaQuery.of(context).size.height - 80,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: getBillingData.billingAddress.existingAddresses.toList().map((e) {
                            return ListTile(
                              title: Text(e.address1),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                setState(() {
                                  bloc.storePickup = true;
                                  bloc.selectedExistingShippingAddress = e;
                                  bloc.saveShippingAddress(isNewAddress: true);
                                  Navigator.of(context).pop();

                                });


                              },
                            );



                          }).toList(),



                        ),


                      ),
                    ),
                    // btnNewAddress,
                  ],
                ),

              );

            });



      },

      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 12,
            bottom: 12,
            top: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 32,
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${confirmModel.cart.orderReviewData.shippingAddress.firstName} ${confirmModel.cart.orderReviewData.billingAddress.lastName}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${confirmModel.cart.orderReviewData.shippingAddress.address1} ${confirmModel.cart.orderReviewData.billingAddress.stateProvinceName} ${confirmModel.cart.orderReviewData.billingAddress.zipPostalCode}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.edit_outlined,
                    color: Colors.grey,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );


    var storeAdrsCard = Card(
      child: ListTile(
        leading: Icon(Icons.pin_drop),
        title: Text(_globalService.getString(Const.PICK_UP_POINT_ADDRESS)),
        subtitle: Text(getFormattedAddress(
            confirmModel.cart.orderReviewData.pickupAddress)),
      ),
    );

    var shippingMethodCard = Card(
      child: ListTile(
        leading: Icon(Icons.local_shipping, color: Colors.blueAccent),
        title: Text(_globalService.getString(Const.SHIPPING_METHOD)),
        subtitle: Text(confirmModel.cart.orderReviewData.shippingMethod ?? ''),
      ),
    );

    // var paymetnMethodCard = Card(
    //   child: ListTile(
    //     leading: Icon(Icons.payment_outlined),
    //     title: Text(_globalService.getString(Const.PAYMENT_METHOD)),
    //     subtitle: Text(confirmModel.cart.orderReviewData.paymentMethod ?? ''),
    //   ),
    // );
    // //
    //paymentMethodModel.paymentMethods.toList().forEach((element) {
    // print(element.name);
    // });

    if (paymentMethodModel.paymentMethods.any((element) =>
    element.customProperties.displayOrder > 600 &&
        element.customProperties.displayOrder <= 800));






    var paymetnMethodCard = GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext bc) {
              return Container(
                height: MediaQuery.of(context).size.height - 80,
                child: ListView(
                    children: ListTile.divideTiles(
                        context: context,
                        tiles: [
                          ...((){
                            var ewallet = ExpansionTile(
                              title: Text(
                                'E-Wallet',
                              ),
                              children:  paymentMethodModel.paymentMethods.where((element) => element.customProperties.displayOrder != null
                                  && element.customProperties.displayOrder > 100
                                  && element.customProperties.displayOrder <= 200).map((e) {
                                return ListTile(
                                  title: Text(e.name),
                                  trailing: e.logoUrl?.isNotEmpty == true ?
                                  Image.network(
                                    e.logoUrl ?? '',
                                    height: 16,
                                  )
                                      : null,
                                  onTap: () {
                                    setState(() {

                                      bloc.selectedPaymentMethod = e;
                                      bloc.savePaymentMethod();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                );
                              }).toList(),
                            );

                            var installment = ExpansionTile(

                              title: Text(
                                'Credit Card Installment',
                              ),
                              children:  paymentMethodModel.paymentMethods.where((element) => element.customProperties.displayOrder != null
                                  && element.customProperties.displayOrder > 200
                                  && element.customProperties.displayOrder <= 300).map((e) {
                                return ListTile(
                                  title: Text(e.name),
                                  trailing: e.logoUrl?.isNotEmpty == true ?
                                  Image.network(
                                    e.logoUrl ?? '',
                                    height: 16,
                                  )
                                      : null,
                                  onTap: () {
                                    setState(() {

                                      bloc.selectedPaymentMethod = e;
                                      bloc.savePaymentMethod();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                );
                              }).toList(),
                            );

                            var paylater = ExpansionTile(
                              title: Text(
                                'Buy Now Pay Later',
                              ),
                              children:  paymentMethodModel.paymentMethods.where((element) => element.customProperties.displayOrder != null
                                  && element.customProperties.displayOrder > 300
                                  && element.customProperties.displayOrder <= 400).map((e) {
                                return ListTile(
                                  title: Text(e.name),
                                  trailing: e.logoUrl?.isNotEmpty == true ?
                                  Image.network(
                                    e.logoUrl ?? '',
                                    height: 16,
                                  )
                                      : null,
                                  onTap: () {
                                    setState(() {

                                      bloc.selectedPaymentMethod = e;
                                      bloc.savePaymentMethod();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                );
                              }).toList(),
                            );

                            var otc = ExpansionTile(
                              title: Text(
                                'Over the Counter',
                              ),
                              children:  paymentMethodModel.paymentMethods.where((element) => element.customProperties.displayOrder != null
                                  && element.customProperties.displayOrder > 400
                                  && element.customProperties.displayOrder <= 500).map((e) {
                                return ListTile(
                                  title: Text(e.name),
                                  trailing: e.logoUrl?.isNotEmpty == true ?
                                  Image.network(
                                    e.logoUrl ?? '',
                                    height: 16,
                                  )
                                      : null,
                                  onTap: () {
                                    setState(() {

                                      bloc.savePaymentMethod();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                );
                              }).toList(),

                            );
                            var btrsfr = ExpansionTile(
                                title: Text('Bank Transfer Manual'),
                                children: paymentMethodModel.paymentMethods.where((element) =>
                                element.customProperties.displayOrder != null &&
                                    element.customProperties.displayOrder > 500 &&
                                    element.customProperties.displayOrder <= 800).map((e) {
                                  return ListTile(
                                    title: Text(e.name),
                                    trailing: e.logoUrl?.isNotEmpty == true
                                        ? Image.network(
                                      e.logoUrl ?? '',
                                      height: 16,
                                    )
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        bloc.selectedPaymentMethod = e;
                                        bloc.savePaymentMethod();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  );
                                }).toList()


                            );










                            return [
                              if (ewallet.children.isNotEmpty)
                                ewallet,
                              if (installment.children.isNotEmpty  )
                                installment,
                              if (paylater.children.isNotEmpty)
                                paylater,
                              if (otc.children.isNotEmpty)
                                otc,
                              if(btrsfr.children.isNotEmpty)
                                btrsfr,


                            ];
                          }()),

                          ...paymentMethodModel.paymentMethods.where((element) => element.customProperties.displayOrder == null || element.customProperties.displayOrder <= 100)
                              .map((e) {
                            return ListTile(
                              title: Text(e.name),
                              trailing: e.logoUrl?.isNotEmpty == true ?
                              Image.network(
                                e.logoUrl ?? '',
                                height: 16,
                              )
                                  : null,
                              onTap: () {
                                setState(() {

                                  bloc.selectedPaymentMethod = e;
                                  bloc.savePaymentMethod();
                                  Navigator.of(context).pop();
                                });
                              },
                            );
                          }).toList()
                        ]
                    )
                ),
              );
            });
      },
      child: Card(
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: 12,
              bottom: 12,
              top: 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Container(),
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        'Payment Method',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 38,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                bloc.selectedPaymentMethod != null ? bloc.selectedPaymentMethod.name ?? confirmModel.cart.orderReviewData.paymentMethod ?? '' : '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.orange
                                )
                            ),
                            Text(
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey
                                )
                            ),
                            // if(paymentMethodModel.customProperties.displayOrder == 700)paymentInfo,

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.grey,
                ),
              ],
            ),
          )
      ),
    );





    // var paymentInfo = Card(
    //   child: ListTile(
    //     leading: Icon(Icons.payments_sharp),
    //     title: Text(paymentInfoModel.getPaymentInfo()), // replace with a method that returns the payment info as a string
    //     return Scaffold(
    //
    //
    //     body: paymentInfo,
    //   ),
    //   ),
    // );





// get the description text from the API
//     Future<String> getDescriptionText() async {
//       final response = await http.get(Uri.parse('https://your-nopcommerce-app.com/configuration/description-text'));
//
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         return jsonResponse['DescriptionText'];
//       } else {
//         throw Exception('Failed to get description text.');
//       }
//     }
//
//     var paymentInfos = Card(
//       child: ListTile(
//         title: Text(_globalService.getString(Const.PAYMENT_INFO)),
//         subtitle: FutureBuilder<String>(
//           future: getDescriptionText(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 8),
//                   Text('Payment Description: '),
//                   Text(snapshot.data),
//                 ],
//               );
//             } else if (snapshot.hasError) {
//               return Text('Failed to load payment description');
//             } else {
//               return CircularProgressIndicator();
//             }
//           },
//         ),
//       ),
//     );

    var paymentInfos = InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext bc) {
            return Container(
              height: MediaQuery.of(context).size.height - 300,
              child: ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      title: Text(''),
                      subtitle: Html(
                        data: bloc.selectedPaymentMethod?.description ?? 'Null',
                      ),
                    ),
                  ],
                ).toList(),
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 12,
            bottom: 12,
            top: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Opacity(
                  opacity: 0.0,
                  child: Icon(
                    Icons.account_tree_outlined,
                    color: Colors.blue,
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      'Payment Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 32,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              final Uri params = Uri(
                                scheme: 'mailto',
                                path: 'finance@stork.ph',
                                query:
                                'subject=Proof%20of%20Payment&body=Dear%20Finance%20Team,%0A%0APlease%20find%20attached%20my%20proof%20of%20payment.%0A%0AThank%20you.%0A%0ARegards,%0A[Your%20Name]',
                              );
                              String emailUrl = params.toString();
                              launch(emailUrl);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Send proof of payment to:',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  'finance@stork.ph',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.lightBlueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(
                Icons.edit_outlined,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );


    //
    // Container paymentInfos = Container(
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: Colors.grey[300],
    //       width: 1,
    //     ),
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   padding: const EdgeInsets.all(16),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           const Icon(Icons.payment_outlined),
    //           const SizedBox(width: 10),
    //           Text(
    //             _globalService.getString(Const.PAYMENT_INFO ?? ''),
    //             style: const TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 16,
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(height: 10),
    //       GestureDetector(
    //         onTap: () {
    //           // Handle the click event here
    //         },
    //         child: Html(
    //           data: bloc.selectedPaymentMethod?.description ?? 'Null',
    //         ),
    //       ),
    //     ],
    //   ),
    // );



    //  print(descriptionText);












    paymentMethodModel.paymentMethods.toList().forEach((element) {
      print(element.name);
    });



    // paymentInfoModel.paymentViewComponentName.toList().forEach((element) {
    //
    // });
    var cartItems = ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: confirmModel.cart.items.length,
      itemBuilder: (context, index) {
        return CartListItem(
          item: confirmModel.cart.items[index],
          onClick: (map) {},
          editable: false,
        );
      },
    );
    var filteredPaymentMethods = paymentMethodModel.paymentMethods.where((element) =>
    element.customProperties.displayOrder > 600 &&
        element.customProperties.displayOrder <= 800);
    var selectedAttributes = Card(
      child: ListTile(
        title: Text(_globalService.getString(Const.SELECTED_ATTRIBUTES)),
        subtitle: HtmlWidget(
          confirmModel.selectedCheckoutAttributes ?? '',
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Column(
        children: [
          shippingAdrsCard,
          if (confirmModel.cart.orderReviewData.display )
            billingAdrsCard,
          if (confirmModel.cart.orderReviewData.display &&
              confirmModel.cart.orderReviewData.isShippable &&
              !confirmModel.cart.orderReviewData.selectedPickupInStore)
            if (confirmModel.cart.orderReviewData.display &&
                confirmModel.cart.orderReviewData.selectedPickupInStore)
              storeAdrsCard,

          // if (confirmModel.cart.orderReviewData.display) shippingMethodCard,
          cartItems,
          if (confirmModel.cart.orderReviewData.display && ((double.tryParse(confirmModel.orderTotals.orderTotal.replaceAll(RegExp(r'[^0-9\.]'), '')) ?? 0) > 0) ) paymetnMethodCard,
          // (paymentMethodModel.paymentMethods.where((element) =>   element.customProperties.displayOrder > 100 && element.customProperties.displayOrder <= 200).isNotEmpty)
          // if (confirmModel.cart.orderReviewData.display && bloc.selectedPaymentMethod.customProperties.displayOrder == 700) paymentInfo,
          if (confirmModel.cart.orderReviewData.display &&  bloc.selectedPaymentMethod.customProperties.displayOrder == 700 ) paymentInfos,
          if (confirmModel.selectedCheckoutAttributes.isNotEmpty)
            selectedAttributes,

          SizedBox(height: 10),
          OrderTotalTable(orderTotals: confirmModel.orderTotals),
          SizedBox(height: 10),
          // if(bloc.warningMsg.isEmpty && confirmModel.cart?.hideCheckoutButton != true)
          //   Row(
          //     children: [
          //       Expanded(
          //         child: CustomButton(
          //           label: GlobalService().getString(Const.CONFIRM_BUTTON).toUpperCase(),
          //           onClick: () {
          //             bloc.confirmOrder();
          //           },
          //         ),
          //       )
          //     ],
          //   ),

          Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 18,
                  right: 12,
                  bottom: 12,
                  top: 12,
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'By clicking "Checkout", you agree to our ',
                                      style: TextStyle(
                                          color: Colors.black
                                      )
                                  ),
                                  TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      )
                                  ),
                                  TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                          color: Colors.black
                                      )
                                  ),
                                ]
                            )
                        ),
                      )
                    ]
                ),
              )
          )
        ],
      ),
    );
  }

}

// class PaymentConfiguration {
//   String descriptionText;
//
//   PaymentConfiguration({ this.descriptionText});
//
//   factory PaymentConfiguration.fromJson(Map<String, dynamic> json) {
//     return PaymentConfiguration(
//       descriptionText: json['DescriptionText'],
//     );
//   }
// }
