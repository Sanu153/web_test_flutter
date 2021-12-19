import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MyBuySellAnnotation extends StatelessWidget {
  final double price;
  final DateTime dateTime;
  final hasBuy;

  final double minValue = 8.0;

  MyBuySellAnnotation({Key key, this.price, this.dateTime, this.hasBuy = true});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: "This is A Tooltip",
//        padding: EdgeInsets.all(minValue * 2),
        child: Container(
          decoration: BoxDecoration(
              color: hasBuy ? greenColor : redColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(minValue),
          child: Text(
            "",
//            "${hasBuy ? 'B' : 'S'}",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
          ),
        ));
  }
}
