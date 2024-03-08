// To parse this JSON data, do
//
//     final pushNotificationModel = pushNotificationModelFromJson(jsonString);

import 'dart:convert';

PushNotificationModel pushNotificationModelFromJson(String str) => PushNotificationModel.fromJson(json.decode(str));

String pushNotificationModelToJson(PushNotificationModel data) => json.encode(data.toJson());

class PushNotificationModel {
  PushNotificationModel({
    this.notificationForeground,
    this.title,
    this.body,
    this.itemType,
    this.itemId,
    this.bigPicture,
  });

  String notificationForeground;
  String title;
  String body;
  String itemType;
  String itemId;
  String bigPicture;

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) => PushNotificationModel(
    notificationForeground: json["notification_foreground"] == null ? null : json["notification_foreground"],
    title: json["title"] == null ? null : json["title"],
    body: json["body"] == null ? null : json["body"],
    itemType: json["itemType"] == null ? null : json["itemType"],
    itemId: json["itemId"] == null ? null : json["itemId"],
    bigPicture: json["bigPicture"] == null ? null : json["bigPicture"],
  );

  Map<String, dynamic> toJson() => {
    "notification_foreground": notificationForeground == null ? null : notificationForeground,
    "title": title == null ? null : title,
    "body": body == null ? null : body,
    "itemType": itemType == null ? null : itemType,
    "itemId": itemId == null ? null : itemId,
    "bigPicture": bigPicture == null ? null : bigPicture,
  };
}
