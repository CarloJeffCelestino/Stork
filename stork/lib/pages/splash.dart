import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nopcart_flutter/ScopedModelWrapper.dart';
import 'package:nopcart_flutter/networking/AppException.dart';
import 'package:nopcart_flutter/pages/tabs-screen/error_screen.dart';
import 'package:nopcart_flutter/pages/tabs-screen/tabs_screen.dart';
import 'package:nopcart_flutter/repository/SettingsRepository.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:scoped_model/scoped_model.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SettingsRepository repository = SettingsRepository();

  @override
  void initState() {
    super.initState();
    getAppLandingData();
    // print("Splash initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage(AppConstants.splashBackground),
            //     fit: BoxFit.cover)
        ),
        child: Center(
          child: Image.asset(
            'assets/splash_image.png',
          )
        ),
      ),
    );
  }

  getAppLandingData() async {
    await prepareSessionData();

    repository.fetchAppLandingSettings().then((value) {
      GlobalService().setAppLandingData(value.data);

      // Settings the value on ScopedModel
      AppModel model = ScopedModel.of(context);
      model.updateAppLandingData(value.data);

      Navigator.pushReplacementNamed(context, TabsScreen.routeName);
    }).onError((error, stackTrace) {
      // go to error page
      Navigator.of(context)
          .pushNamed(
            ErrorScreen.routeName,
            arguments: ErrorScreenArguments(
              errorMsg: error.toString(),
              errorCode: error is AppException ? error.getErrorCode() : 0,
            ),
          )
          .then((shouldReload) => {
                if (shouldReload == 'retry')
                  getAppLandingData()
                else
                  // TODO check whether it works on iOS too
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop')
              });
    });
  }
}
