import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MyBuySellTradeCategory extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color textColor;
  final Widget trailing;

  MyBuySellTradeCategory(
      {@required this.title,
      @required this.onPressed,
      @required this.textColor,
      this.trailing});

  final double _padding = 8.0;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final paddingPlus =
        EdgeInsets.symmetric(horizontal: _padding * 2, vertical: _padding);
    final paddingNeg = EdgeInsets.symmetric(horizontal: 3, vertical: 3);
    TextStyle t = TextStyle(
        fontSize: deviceHeight > 380 ? 12 : 10,
        color: textColor == null ? buySellTextColor : textColor);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: secondaryColor,
          border: Border.all(color: secondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(_padding - 3)),
          shape: BoxShape.rectangle),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: double.infinity,
//            height: 37.0,
            padding: deviceHeight > 380 ? paddingPlus : paddingNeg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    "$title",
                    style: t,
                    overflow: textColor == null
                        ? TextOverflow.ellipsis
                        : TextOverflow.ellipsis,
                  ),
                ),
                trailing == null
                    ? Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: buySellTextColor,
                      )
                    : trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
