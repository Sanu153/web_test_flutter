import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MyCustomNumberButton extends StatelessWidget {
  double minValue = 8.0;

  final String text;
  final Function onPressed;

  MyCustomNumberButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final t = Theme
        .of(context)
        .textTheme
        .subhead;
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
//          radius: 15.0,
          child: Container(
            padding: EdgeInsets.all(minValue),
            child: Center(
              child: Text(
                text,
                style: t.apply(color: Colors.white, fontWeightDelta: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
