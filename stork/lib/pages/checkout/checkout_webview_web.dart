import 'package:flutter/widgets.dart';
import 'package:nopcart_flutter/pages/checkout/checkout_webview_interface.dart';
import 'dart:js' as js;
import 'dart:html' as html;

class WebCheckoutWebViewRender implements CheckoutWebViewRender {


  @override
  Widget renderValue({String screenTitle, String url, int customerId, String guid, @required BuildContext context, Function function}) {
    // final cookie = html.document.cookie ?? '';
    //
    // if (cookie.isNotEmpty) {
    //   final entity = cookie.split("; ").map((item) {
    //     final split = item.split("=");
    //     return MapEntry(split[0], split[1]);
    //   });
    //   final cookieMap = Map.fromEntries(entity);
    //
    //   print(cookieMap.toString());
    //
    // }final cookie = html.document.cookie ?? '';
    //     //
    //     // if (cookie.isNotEmpty) {
    //     //   final entity = cookie.split("; ").map((item) {
    //     //     final split = item.split("=");
    //     //     return MapEntry(split[0], split[1]);
    //     //   });
    //     //   final cookieMap = Map.fromEntries(entity);
    //     //
    //     //   print(cookieMap.toString());
    //     //
    //     // }



    if (url.contains('redirect')) {
      url = url + 'web?checkoutGuid=${guid}&customerId=${customerId}';
      print(url);
      html.window.open(url, '_self');
    }
    else {
      var nextStep = url[url.length - 1];
      print(url);
      print(nextStep);
      Navigator.pop(context, '6');

    }
    return Text('Loading...');

  }
}

CheckoutWebViewRender getCheckoutWebViewRender() => WebCheckoutWebViewRender();