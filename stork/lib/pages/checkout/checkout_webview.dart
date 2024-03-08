
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';
import 'package:nopcart_flutter/pages/checkout/checkout_webview_interface.dart';
import 'package:nopcart_flutter/utils/CheckoutConstants.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutWebView extends StatefulWidget {
  static const routeName = '/checkoutWebView';

  @override
  _CheckoutWebViewState createState() => _CheckoutWebViewState();
}


class _CheckoutWebViewState extends State<CheckoutWebView> {
  CookieManager cookieManager = CookieManager.instance();

  // InAppWebViewSettings options = InAppWebViewSettings(
  //     useShouldOverrideUrlLoading: true,
  //     mediaPlaybackRequiresUserGesture: false,
  //     javaScriptCanOpenWindowsAutomatically: true,
  //     javaScriptEnabled: true,
  //     userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
  //     useHybridComposition: true,
  //     thirdPartyCookiesEnabled: true,
  //     allowsInlineMediaPlayback: true,
  //     sharedCookiesEnabled: true,
  //     // crossPlatform: InAppWebViewOptions(
  //     //     useShouldOverrideUrlLoading: true,
  //     //     mediaPlaybackRequiresUserGesture: false,
  //     //     javaScriptCanOpenWindowsAutomatically: true,
  //     //     javaScriptEnabled: true,
  //     //     userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"
  //     // ),
  //     // android: AndroidInAppWebViewOptions(
  //     //   useHybridComposition: true,
  //     //   thirdPartyCookiesEnabled: true,
  //     // ),
  //     // ios: IOSInAppWebViewOptions(
  //     //     allowsInlineMediaPlayback: true,
  //     //     sharedCookiesEnabled: true
  //     // )
  // );

  Future<void> clearCookie() async {
    await cookieManager.deleteAllCookies();
    return;
  }

  @override
  Widget build(BuildContext context) {
    CheckoutWebViewScreenData args = ModalRoute.of(context).settings.arguments;
    var url = args.action == CheckoutConstants.PaymentInfo
        ? Endpoints.paymentInfoUrl
        : Endpoints.redirectUrl;

    // add order id in case of repost payment
    if(args.action == CheckoutConstants.RetryPayment)
      url = '$url&orderId=${args.orderId}';

    // if (kIsWeb) {
    //   print(url);
    //
    //   return WebViewX(
    //     initialContent: '<h2> Loading... </h2>',
    //     initialSourceType: SourceType.html,
    //     onWebViewCreated: (controller) {
    //       webViewController = controller;
    //       webViewController.loadContent(
    //         url,
    //         SourceType.url,
    //       );
    //     },
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height,
    //     onPageFinished: (message) {
    //       final url = message;
    //
    //       print('asdasdtest');
    //       print(url);
    //
    //       if (url.contains("page-not-found")) {
    //         Navigator.pop(context);
    //       } else if(url.contains("/step/")) {
    //         var nextStep = url[url.length - 1];
    //         Navigator.pop(context, nextStep);
    //       }
    //       else if(url.contains("/completed/")) { // || url.contains("/orderdetails")
    //         int orderId = -1;
    //
    //         try {
    //           orderId = int.parse(url.split('/').last);
    //         } catch(e) {
    //           orderId = -1;
    //         }
    //
    //         Navigator.pop(context, orderId);
    //       }
    //     },
    //   );
    // }



    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(args.screenTitle ?? ''),
      ),
      body: FutureBuilder(
        future: clearCookie(),
        builder: (context, snapshot)  {
          var renderCheckoutWebView = CheckoutWebViewRender();


          return renderCheckoutWebView.renderValue(
              screenTitle: args.screenTitle ?? '',
              url: url,
              context: context,
              guid: args.checkoutGuid ?? '',
              customerId: args.customerId,
              function: () {
              });
        },
      ),
    );
  }
}

class CheckoutWebViewScreenData {
  int action;
  String screenTitle;
  int orderId;
  String checkoutGuid;
  int customerId;

  CheckoutWebViewScreenData({@required this.action, @required this.screenTitle, this.orderId, this.checkoutGuid, this.customerId});
}
