import 'package:flutter/material.dart';
import 'package:nopcart_flutter/pages/more/barcode_scanner_screen.dart';
import 'package:nopcart_flutter/pages/more/contact_us_screen.dart';
import 'package:nopcart_flutter/pages/more/settings_screen.dart';
import 'package:nopcart_flutter/pages/more/topic_screen.dart';
import 'package:nopcart_flutter/pages/more/vendor_list_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  GlobalService _globalService = GlobalService();

  @override
  Widget build(BuildContext context) {

    var iconColor = Theme.of(context).primaryColor;

    return Padding(
      padding: defaultPadding(),
      child: Column(
        children: [
          Card(
            child: InkWell(
              child: ListTile(
                leading: Icon(Icons.qr_code_scanner, color: iconColor),
                title: Text(_globalService.getString(Const.MORE_SCAN_BARCODE)),
              ),
              onTap: () => Navigator.pushNamed(
                context,
                BarcodeScannerScreen.routeName,
              ),
            ),
          ),
          Card(
            child: InkWell(
              child: ListTile(
                leading: Icon(Icons.settings, color: iconColor),
                title: Text(_globalService.getString(Const.MORE_SETTINGS)),
              ),
              onTap: () => Navigator.pushNamed(
                context,
                SettingsScreen.routeName,
              ),
            ),
          ),
          Card(
            child: InkWell(
              child: ListTile(
                leading: Icon(Icons.copyright, color: iconColor),
                title: Text(_globalService.getString(Const.MORE_PRIVACY_POLICY)),
              ),
              onTap: () => Navigator.pushNamed(
                context,
                TopicScreen.routeName,
                arguments: TopicScreenArguments(topicName: AppConstants.TOPIC_PRIVACY_POLICY),
              ),
            ),
          ),
          Card(
            child: InkWell(
              child: ListTile(
                leading: Icon(Icons.info_outline, color: iconColor),
                title: Text(_globalService.getString(Const.MORE_ABOUT_US)),
              ),
              onTap: () => Navigator.pushNamed(
                context,
                TopicScreen.routeName,
                arguments: TopicScreenArguments(topicName: AppConstants.TOPIC_ABOUT_US),
              ),
            ),
          ),
          Card(
            child: InkWell(
              child: ListTile(
                leading: Icon(Icons.contact_mail_outlined, color: iconColor),
                title: Text(_globalService.getString(Const.MORE_CONTACT_US)),
              ),
              onTap: () => Navigator.of(context).pushNamed(ContactUsScreen.routeName),
            ),
          ),
          if(_globalService.getAppLandingData()?.showAllVendors == true)
            Card(
              child: InkWell(
                child: ListTile(
                  leading: Icon(Icons.people_outline, color: iconColor),
                  title: Text(_globalService.getString(Const.PRODUCT_VENDOR)),
                ),
                onTap: () => Navigator.of(context).pushNamed(VendorListScreen.routeName),
              ),
            ),
        ],
      ),
    );
  }
}
