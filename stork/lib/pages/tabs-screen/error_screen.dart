import 'package:flutter/material.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/shared_pref.dart';

class ErrorScreen extends StatefulWidget {
  static const routeName = '/errorScreen';
  final ErrorScreenArguments screenArgument;
  const ErrorScreen({Key key, this.screenArgument}) : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/ic_error.png',
                fit: BoxFit.scaleDown,
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  widget.screenArgument?.errorMsg?.isEmpty == true
                      ? 'Something Went Wrong'
                      : widget.screenArgument.errorMsg,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    if(widget.screenArgument.errorCode == AppConstants.tokenExpireErrorCode) {
                      SessionData().clearUserSession().then((value) =>
                          Navigator.of(context).pop('retry'));
                    } else {
                      Navigator.of(context).pop('retry');
                    }
                  },
                child: Text(widget.screenArgument.errorCode ==
                        AppConstants.tokenExpireErrorCode
                    ? 'Continue As Guest'
                    : 'Try Again'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorScreenArguments {
  String errorMsg;
  int errorCode;

  ErrorScreenArguments({
    this.errorMsg,
    this.errorCode,
  });
}
