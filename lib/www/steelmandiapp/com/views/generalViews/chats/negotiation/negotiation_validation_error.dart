import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';

class MyNegotiationValidationError extends StatelessWidget {
  final NegotiationValidationError validationError;

  MyNegotiationValidationError({@required this.validationError});

  final double minValue = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: secondaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(minValue * 2))),
      padding: EdgeInsets.all(minValue),
      margin: EdgeInsets.all(minValue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Quantity Remaining",
            style: Theme.of(context)
                .textTheme
                .caption
                .apply(color: Colors.white70),
          ),
          Text(
            "${validationError.remainingQuantity ?? '00'}",
            style: Theme.of(context)
                .textTheme
                .headline
                .apply(color: Colors.white70),
          ),
          Text(
            "${validationError.responseMessage ?? "Quantity can't be greater than the remaining quantity"}",
            style: Theme.of(context)
                .textTheme
                .body2
                .apply(color: Colors.yellow[800]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
