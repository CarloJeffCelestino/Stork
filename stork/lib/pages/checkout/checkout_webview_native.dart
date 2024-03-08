import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/pages/checkout/checkout_webview_interface.dart';

class NativeCheckoutWebViewRender implements CheckoutWebViewRender {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    // useShouldOverrideUrlLoading: true,
    // mediaPlaybackRequiresUserGesture: false,
    // javaScriptCanOpenWindowsAutomatically: true,
    // javaScriptEnabled: true,
    // userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
    // useHybridComposition: true,
    // thirdPartyCookiesEnabled: true,
    // allowsInlineMediaPlayback: true,
    // sharedCookiesEnabled: true,
    crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptCanOpenWindowsAutomatically: true,
        javaScriptEnabled: true,
        userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      thirdPartyCookiesEnabled: true,
    ),
    ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
        sharedCookiesEnabled: true
    )
  );

  @override
  Widget renderValue({String screenTitle, String url, int customerId, String guid, @required BuildContext context, Function function}) {


    return InAppWebView(
     initialUrlRequest: URLRequest(
       url: Uri.parse(url),
       headers: ApiBaseHelper().getRequestHeader(),
     ),
     initialOptions: options,
     onWebViewCreated: (controller) async {
       await controller.setOptions(options: options);
     },

     onLoadStop: (controller, mUrl) async {
       final url = mUrl.toString();

       if (url.contains("page-not-found")) {
         Navigator.pop(context);
       } else if(url.contains("/step/")) {
         var nextStep = url[url.length - 1];

         print('this is a test');
         print(url);
         print(nextStep);
         Navigator.pop(context, nextStep);
       }
       else if(url.contains("/completed/")) { // || url.contains("/orderdetails")
         int orderId = -1;

         try {
           orderId = int.parse(url.split('/').last);
         } catch(e) {
           orderId = -1;
         }

         Navigator.pop(context, orderId);
       }
     },
   );
  }
}

CheckoutWebViewRender getCheckoutWebViewRender() => NativeCheckoutWebViewRender();