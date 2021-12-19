import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/custom_keypad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data/raw_data.dart';

class MyBuySellQuantityList extends StatelessWidget {
  final Function onSelected;
  final String unit;

  MyBuySellQuantityList({@required this.onSelected, this.unit});

  int _selectedIndex = 0;

  List<double> _quantityList = quantityList;

  double minValue = 8.0;

  void _onFinished(double value) {
    ////print("Quantity Enetered: $value");
  }

  void _onKeyPadTap(BuildContext context) {
//    Navigator.of(context).pop();
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
        itemCount: _quantityList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onDoubleTap: () => onSelected(_quantityList[index]),
            onTap: () {
              onSelected(_quantityList[index]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: minValue, horizontal: minValue * 1.2),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.filter_hdr,
                    size: 14.0,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      "${_quantityList[index].toStringAsFixed(0)} ${unit ?? 'T'}",
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

  Widget _buildLastOrder(BuildContext context) {
    final t = Theme.of(context)
        .textTheme
        .subhead
        .apply(color: Colors.white70, fontWeightDelta: 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        Padding(
//          padding:
//              EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
//          child: Text(
//            "LAST ORDER",
//            textAlign: TextAlign.left,
//            style: Theme.of(context)
//                .textTheme
//                .subtitle
//                .apply(color: Colors.white54),
//          ),
//        ),
//        Padding(
//          padding: EdgeInsets.symmetric(
//              horizontal: minValue * 1.2, vertical: minValue - 5),
//          child: Row(
//            children: <Widget>[
//              Icon(
//                Icons.filter_hdr,
//                size: 15.0,
//                color: iconColor,
//              ),
//              SizedBox(
//                width: 5,
//              ),
//              Flexible(
//                child: Text(
//                  "${_selectedItem.toStringAsFixed(0)} t",
//                  style: t,
//                  overflow: TextOverflow.ellipsis,
//                ),
//              ),
//            ],
//          ),
//        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2.0),
              child: IconButton(
                  iconSize: 25.0,
                  icon: Icon(
                    Icons.keyboard,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () => _onKeyPadTap(context))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
          child: Text(
            "PRESETS",
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .subtitle
                .apply(color: Colors.white54),
          ),
        ),
        Expanded(child: _buildList(context)),
        Align(
          child: _buildLastOrder(context),
          alignment: Alignment.bottomLeft,
        )
      ],
    );
  }
}
