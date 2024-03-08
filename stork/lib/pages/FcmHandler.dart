import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nopcart_flutter/model/PushNotificationModel.dart';
import 'package:nopcart_flutter/pages/account/order/order_details_screen.dart';
import 'package:nopcart_flutter/pages/account/registration_sceen.dart';
import 'package:nopcart_flutter/pages/more/topic_screen.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/repository/SettingsRepository.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';
import 'package:nopcart_flutter/utils/NotificationUtils.dart';
import 'package:nopcart_flutter/utils/NotificationType.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:nopcart_flutter/utils/shared_pref.dart';

import '../firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("FCM background message: ${message?.data?.toString()}");
  return;
}

class FcmHandler extends StatefulWidget {
  final Widget child;
  const FcmHandler({Key key, @required this.child}) : super(key: key);

  @override
  _FcmHandlerState createState() => _FcmHandlerState();
}

class _FcmHandlerState extends State<FcmHandler> {

  static bool initialized = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const DarwinNotificationDetails iosLiquidChannel = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: "default");

  Future selectNotification(NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      log('notification payload android: ${notificationResponse.payload}');
      setupNotificationClickAction(notificationResponse.payload);
    }
  }

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload) async {
    if (payload != null) {
      log('notification payload android: $payload');
      setupNotificationClickAction(payload);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!initialized) initializeFcm();
  }

  @override
  Widget build(BuildContext context) {

    return widget.child;
  }

  Future<void> initializeFcm() async {
    if (!initialized) {
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

      final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );

      final InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: selectNotification,
      );

      // initialize Firebase
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
      );
      log("Requesting FCM token...");

      // turn off crash reporting for debug mode
      if (!kIsWeb && kDebugMode) {
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false);
      }

      // Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      try {
        String token = await FirebaseMessaging.instance.getToken();
        log("FCM token: $token");

        GlobalService().setFcmToken(token);

        initialized = true;

        // post token to server
        var response = await SettingsRepository().postFcmToken(token);
        log("FCM Token sent to server: ${response.toJson().toString()}");
      } catch (e) {
        log("FCM token error: $e");
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('FCM foreground message: ${message.data}\n notification - ${message
          .notification ?? ''}');



      if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
        SessionData().addFeed('${message.data['title'] ?? ''}\n${message.data['body'] ?? ''}');
        flutterLocalNotificationsPlugin.show(
          0,
          message.data['title'],
          message.data['body'],
          NotificationUtils().getNotificationSpecifics(),
          payload: json.encode(message.data),
        );
      }
      else if (defaultTargetPlatform == TargetPlatform.iOS) {
        SessionData().addFeed('${message.notification.title ?? ''}\n${message.notification.body ?? ''}');
        flutterLocalNotificationsPlugin.show(
          0,
          message.notification.title ?? '',
          message.notification.body ?? '',
          NotificationDetails(iOS: iosLiquidChannel),
          payload: json.encode(message.data),
        );
      }
    });

    FirebaseMessaging?.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        setupNotificationClickAction(json.encode(message.data));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setupNotificationClickAction(json.encode(message.data));
    });
  }

  Future<void> setupNotificationClickAction (String payload) async {
    // handle firebase and local notification clicks here

    final data = pushNotificationModelFromJson(payload);

    final itemId = num.tryParse(data.itemId) ?? 0;

    switch (int.tryParse(data.itemType) ?? 0) {
      case NotificationType.PRODUCT:
        Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
            arguments: ProductDetailsScreenArguments(
              id: itemId,
              name: '',
            ));
        break;

      case NotificationType.CATEGORY:
        Navigator.of(context).pushNamed(ProductListScreen.routeName,
            arguments: ProductListScreenArguments(
                id: itemId, name: '', type: GetBy.CATEGORY));
        break;

      case NotificationType.MANUFACTURER:
        Navigator.of(context).pushNamed(ProductListScreen.routeName,
            arguments: ProductListScreenArguments(
                id: itemId, name: '', type: GetBy.MANUFACTURER));
        break;

      case NotificationType.VENDOR:
        Navigator.of(context).pushNamed(ProductListScreen.routeName,
            arguments: ProductListScreenArguments(
                id: itemId, name: '', type: GetBy.VENDOR));
        break;

      case NotificationType.ORDER:
        Navigator.of(context).pushNamed(OrderDetailsScreen.routeName,
            arguments: OrderDetailsScreenArguments(orderId: itemId));
        break;

      case NotificationType.ACCOUNT:
        Navigator.of(context).pushNamed(RegistrationScreen.routeName,
            arguments: RegistrationScreenArguments(getCustomerInfo: true));
        break;

      case NotificationType.TOPIC:
        Navigator.of(context).pushNamed(TopicScreen.routeName,
            arguments: TopicScreenArguments(topicId: itemId));
        break;

      // case NotificationType.FILE_DOWNLOADED:
      //   if(Platform.isAndroid || Platform.isIOS)
      //   openDownloadedFile(data.body);
      //   break;
    }
  }

  // void openDownloadedFile(String path) async {
  //   final _result = await OpenFile.open(path);
  //   // // print('${_result.message} >> ${_result.type.index}');
  //
  //   if(_result.type.index != 0) {
  //     showSnackBar(context, _result.message, true);
  //   }
  // }
}
