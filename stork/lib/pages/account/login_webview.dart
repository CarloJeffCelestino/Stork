
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';
import 'package:nopcart_flutter/utils/CheckoutConstants.dart';
import 'package:nopcart_flutter/utils/LoginConstants.dart';

class LoginWebView extends StatefulWidget {
  static const routeName = '/LoginWebView';

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}


class _LoginWebViewState extends State<LoginWebView> {
  CookieManager cookieManager = CookieManager.instance();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
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
      ));

  Future<void> clearCookie() async {
    await cookieManager.deleteAllCookies();
    return;
  }

  @override
  Widget build(BuildContext context) {
    LoginWebViewScreenData args = ModalRoute.of(context).settings.arguments;
    var url = args.action == LoginConstants.Facebook
        ? Endpoints.facebookUrl
        : Endpoints.pageNotFoundUrl;

    // // add order id in case of repost payment
    // if(args.action == CheckoutConstants.RetryPayment)
    //   url = '$url&orderId=${args.orderId}';

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(args.screenTitle ?? ''),
      ),
      body: FutureBuilder(
        future: clearCookie(),
        builder: (context, snapshot) {
          return InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(url),
              headers: ApiBaseHelper().getRequestHeader(),
            ),
            initialOptions: options,
            onWebViewCreated: (controller) async {
              await controller.setOptions(options: options);
            },

            /*shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.headers;
              // print(uri.toString());

              // return NavigationActionPolicy.CANCEL;

              return NavigationActionPolicy.ALLOW;
            },*/

            onLoadStop: (controller, mUrl) async {
              final url = mUrl.toString();
              print(url);

              if (url.contains("page-not-found")) {
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }
}

class LoginWebViewScreenData {
  int action;
  String screenTitle;

  LoginWebViewScreenData({@required this.action, @required this.screenTitle});
}
