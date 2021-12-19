import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/feature_implement_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';

class TermsAndConditions extends StatelessWidget {
  void _onBack(BuildContext context) async {
    await SystemConfig.makeStatusBarHide();
    SystemConfig.makeDeviceLandscape().then((value) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBack(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white70,
              ),
              onPressed: () => _onBack(context)),
          title: Text(
            "Terms and Conditions",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: FeatureImplement(),
        ),
      ),
    );
  }
}
