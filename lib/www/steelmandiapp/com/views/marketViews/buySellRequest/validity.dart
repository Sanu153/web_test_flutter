import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/custom_keypad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data/raw_data.dart';

class MyBuySellValidityList extends StatelessWidget {
  final Function onSelected;

  MyBuySellValidityList({@required this.onSelected});

  double minValue = 8.0;

  void _onFinished(double value) {
    ////print("Quantity Enetered: $value");
  }

  void _onKeyPadTap(BuildContext context) {
    Navigator.of(context).pop();
    DialogHandler.openMyCustomKeyPadDialog(
        context: context,
        child: MyCustomNumberKeyPad(
          title: "QUANTITY",
          onFinished: onSelected,
        ));
  }

  Widget _buildList(BuildContext context) {
    final t = Theme.of(context)
        .textTheme
        .caption
        .apply(color: Colors.white70, fontWeightDelta: 1);
    return ListView.builder(
        itemCount: validityList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onDoubleTap: () => onSelected(validityList[index]),
            onTap: () {
              onSelected(validityList[index]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: minValue, horizontal: minValue * 1.2),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.filter_hdr,
                    size: 15.0,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      "${validityList[index].toStringAsFixed(0)} Hr",
                      style: t,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
          child: Text(
            "VALIDITY",
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .subtitle
                .apply(color: Colors.white54),
          ),
        ),
        Expanded(child: _buildList(context)),
//        Align(
//          child: _buildLastOrder(context),
//          alignment: Alignment.bottomLeft,
//        )
      ],
    );
  }
}
