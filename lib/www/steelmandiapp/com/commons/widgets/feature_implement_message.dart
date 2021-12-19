import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class FeatureImplement extends StatelessWidget {
  final String title;
  final String subtitle;

  FeatureImplement(
      {Key key, this.title = "Feature not implemented", this.subtitle = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.not_interested,
                size: 18,
                color: greenColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$title",
                style: TextStyle(color: greenColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
