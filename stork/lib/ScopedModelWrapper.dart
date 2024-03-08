import 'package:flutter/material.dart';
import 'package:nopcart_flutter/main.dart';
import 'package:nopcart_flutter/model/AppLandingResponse.dart';
import 'package:nopcart_flutter/utils/shared_pref.dart';
import 'package:scoped_model/scoped_model.dart';

class ScopeModelWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(model: AppModel(), child: MyApp());
  }
}

class AppModel extends Model {
  // Set All default values here
  AppLandingData _appLandingData = AppLandingData(
    primaryThemeColor: '#${Colors.blue.value.toRadixString(16).padLeft(6, '0')}',
    bottomBarActiveColor: '#ffffff',
    bottomBarInactiveColor: '#ffffff',
    bottomBarBackgroundColor: '#${Colors.blue.value.toRadixString(16).padLeft(6, '0')}',
    topBarTextColor: '#ffffff',
    topBarBackgroundColor: '#ffffff',
    totalShoppingCartProducts: 0,
    totalWishListProducts: 0,
    // rtl: true,
    rtl: false,
  );
  int _cartCount = 0;
  bool _darkTheme = false;

  AppLandingData get appLandingData => _appLandingData;
  int get getCartCount => _cartCount;
  bool get isDarkTheme => _darkTheme;

  void updateAppLandingData(AppLandingData newData) {
    _appLandingData = newData;
    _cartCount = newData?.totalShoppingCartProducts ?? 0;
    SessionData().isDarkTheme().then((isEnabled) {
      _darkTheme = isEnabled;
      notifyListeners();
    });
  }

  void seThemeMode(bool isDarkEnable) {
    // debugprint('DarkTheme Enabled -- $isDarkTheme');
    _darkTheme = isDarkEnable;
    notifyListeners();
  }

  void updateCartCount(int count) {
    // debugprint('ScopedModel -- set cart count to $count');
    _cartCount = count;
    notifyListeners();
  }
}