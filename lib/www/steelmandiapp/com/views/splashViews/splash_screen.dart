import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/logo.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';

class SplashViews extends StatelessWidget {
  final double _value = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Theme.of(context).primaryColor,
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      color: Theme
          .of(context)
          .primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyLogo(),
//
          SizedBox(
            height: 30.0,
          ),
          Container(
            padding: EdgeInsets.all(_value),
            child: Text(
              CoreSettings.appName,
              style: Theme
                  .of(context)
                  .textTheme
                  .display1
                  .apply(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: SpinKitThreeBounce(
              color: Colors.yellow[800],
              size: 30.0,
              duration: Duration(seconds: 3),
            ),
          ),
        ],
      ),
    );
  }
}
