import 'package:flutter/widgets.dart';

import 'package:nopcart_flutter/pages/checkout/checkout_webview_stub.dart'
if (dart.library.io) 'package:nopcart_flutter/pages/checkout/checkout_webview_native.dart'
if (dart.library.html) 'package:nopcart_flutter/pages/checkout/checkout_webview_web.dart';

abstract class CheckoutWebViewRender {
  /// returns a value based on the key
  Widget renderValue({String screenTitle, String url, int customerId, String guid, @required BuildContext context, Function function}) {
    return null;
  }

  factory CheckoutWebViewRender() => getCheckoutWebViewRender();
}