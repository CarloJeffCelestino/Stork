import 'package:flutter/material.dart';
import 'package:nopcart_flutter/ScopedModelWrapper.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class Styles {

  static ThemeData darkTheme(AppModel model) {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(
        parseColorInt(model.appLandingData.primaryThemeColor),
        getColorSwatch(parseColor(model.appLandingData.primaryThemeColor)),
      ),
      primaryColor: getColorSwatch(parseColor(model.appLandingData.primaryThemeColor))[900],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
            color: parseColor(model.appLandingData
                .topBarTextColor)
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: parseColor(model.appLandingData.topBarTextColor),
        ),
      ),
      textTheme: ThemeData.dark().textTheme.copyWith(
        headline6: TextStyle(
          fontSize: 22,
        ),
        subtitle1: TextStyle(
          color: Colors.grey[200],
          fontSize: 18,
        ),
        subtitle2: TextStyle(
          fontSize: 16,
        ),
        bodyText2: TextStyle(
          fontSize: 16,
        ),
        button: TextStyle(
          fontSize: 15,
        ),
      ),
      primaryIconTheme: ThemeData.dark().primaryIconTheme.copyWith(
        color: parseColor(model.appLandingData.topBarTextColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
        parseColor(model.appLandingData.bottomBarBackgroundColor),
        elevation: 10,
        selectedItemColor: parseColor(model
            .appLandingData.bottomBarActiveColor), // Need to set from api
        unselectedItemColor: parseColor(model
            .appLandingData.bottomBarInactiveColor), // Need to set from api
        showUnselectedLabels: true,
      ),
      toggleableActiveColor: getColorSwatch(parseColor(model.appLandingData.primaryThemeColor))[900], // checked checkbox color
    );
  }

  static ThemeData lightTheme(AppModel model) {
    return ThemeData(
      primarySwatch: MaterialColor(
        parseColorInt('#${Colors.blue.value.toRadixString(16).padLeft(6, '0')}'),
        getColorSwatch(parseColor('#${Colors.blue.value.toRadixString(16).padLeft(6, '0')}')),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
            color: parseColor('#ffffff')
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: parseColor('#ffffff'),
        ),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
        headline6: TextStyle(
          fontSize: 22,
        ),
        subtitle1: TextStyle(
          color: Colors.grey[800],
          fontSize: 18,
        ),
        subtitle2: TextStyle(
          fontSize: 16,
        ),
        bodyText2: TextStyle(
          fontSize: 16,
        ),
        button: TextStyle(
          fontSize: 15,
        ),
      ),
      primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
        // AppBar icon color
        color: parseColor('#000000'),
      ),
      scaffoldBackgroundColor: parseColor('#F4F4F6'),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
        parseColor('#${Colors.blue.value.toRadixString(16).padLeft(6, '0')}'),
        elevation: 10,
        selectedItemColor: parseColor('#ffffff'), // Need to set from api
        unselectedItemColor: parseColor('#ffffff'), // Need to set from api
        showUnselectedLabels: true,
      ),
    );
  }

  static Color secondaryButtonColor = Color(0x2B2E43 + 0xFF000000);

  static TextStyle productNameTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle2.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
      color: Colors.blue
    );
  }

  static TextStyle productPriceTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle2.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Colors.orange.shade700,
    );
  }

  static Color textColor(BuildContext context) {
    return isDarkThemeEnabled(context) ? Colors.grey[200] : Colors.grey[800];
  }
}