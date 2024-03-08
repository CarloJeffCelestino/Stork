import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:nopcart_flutter/model/UserLoginResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionData {

  static const _keyLoggedIn = '_keyLoggedIn';
  static const _keyAuthToken = '_keyAuthToken';
  static const _keyDeviceId = '_keyDeviceId';
  static const _keyCustomerInfo = '_keyCustomerInfo';
  static const _keyDarkTheme = '_keyDarkTheme';
  static const _keyFeeds = '_keyFeeds';

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthToken) ?? "";
  }

  Future<void> clearUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('_keyLoggedIn');
    await prefs.remove('_keyAuthToken');
    await prefs.remove('_keyCustomerInfo');
    await prefs.remove('_keyFeeds');

    GlobalService().setAuthToken("");

    return;
  }

  Future<void> setUserSession(String authToken, [CustomerInfo customerInfo]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyAuthToken, authToken);

    if(customerInfo!=null) {
      await prefs.setString(_keyCustomerInfo, jsonEncode(customerInfo));
    }

    GlobalService().setAuthToken(authToken);

    return; // success
  }

  Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDeviceId) ?? "";
  }

  void setDeviceId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyDeviceId, id);
  }

  Future<List<String>> getFeeds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var feeds = prefs.getStringList(_keyFeeds) ?? [];

    feeds = feeds.toSet().toList();

    prefs.setStringList(_keyFeeds, feeds);

    return prefs.getStringList(_keyFeeds) ?? [];
  }

  void addFeed(String feed) async {
    if (feed?.isEmpty == true)
      return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var feeds = prefs.getStringList(_keyFeeds) ?? [];


    LineSplitter ls = new LineSplitter();

    List<String> feedString = ls.convert(feed);

    var hasDuplicate = false;

    feeds.forEach((feed) {
      List<String> existFeedString = ls.convert(feed);
      if (feedString.first == existFeedString.first  && feedString.sublist(1, feedString.length - 1).join('\n') == existFeedString.sublist(1, existFeedString.length - 1).join('\n'));
        hasDuplicate = true;
    });

    if (!hasDuplicate) {
      feeds.add(feed + '\n${DateFormat('MM/dd/yyyy kk:mm').format(DateTime.now().toUtc())}');
      prefs.setStringList(_keyFeeds, feeds);
    }

  }

  Future<CustomerInfo> getCustomerInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var info = prefs.getString(_keyCustomerInfo);

    try {
      return CustomerInfo.fromJson(jsonDecode(info));
    } catch(e) {
      return null;
    }
  }

  void setCustomerInfo(CustomerInfo info) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCustomerInfo, jsonEncode(info));
  }

  Future<bool> isDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkTheme) ?? false;
  }

  Future<bool> setDarkTheme(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_keyDarkTheme, isEnabled);
  }

}