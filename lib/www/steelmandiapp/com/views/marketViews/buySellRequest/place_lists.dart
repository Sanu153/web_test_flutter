import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/text_field.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class MyBuySellPlaceList extends StatelessWidget {
  final Function onSelected;

  MyBuySellPlaceList({@required this.onSelected});

  String _selectedItem = '';

  double minValue = 8.0;

  void _onKeyboard(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MyTextFieldViews(
                  title: "Place",
                  onSave: (String place) {
                    onSelected(place);
                  },
                )));
  }

  Widget _buildList(BuildContext context) {
    final t = Theme.of(context)
        .textTheme
        .caption
        .apply(color: Colors.white70, fontWeightDelta: 1);
    final UserModel userModel = Provider.of(context).dataManager.authUser.user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onDoubleTap: () => onSelected(userModel.city),
          onTap: () {
            onSelected(userModel.city);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: minValue, horizontal: minValue * 1.2),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 14.0,
                  color: iconColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    "${userModel.city}",
                    style: t,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
//    return ListView.builder(
//        itemCount: placeList.length,
//        itemBuilder: (context, index) {
//          ;
////
//        });
  }

  Widget _buildLastOrder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: minValue * 1.2, vertical: minValue - 5),
          child: Text(
            " $_selectedItem",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .apply(color: Colors.white70, fontWeightDelta: 1),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2.0),
              child: IconButton(
                  iconSize: 25.0,
                  icon: Icon(
                    Icons.keyboard,
                    color: Colors.white70,
                  ),
                  onPressed: () => _onKeyboard(context))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of(context).dataManager.authUser.user;
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
                .subtitle2
                .apply(color: Colors.white54),
          ),
        ),
        Expanded(
            child: userModel.city == null
                ? Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Please enter place",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SpinKitPulse(
                          itemBuilder: (BuildContext context, int index) {
                            return Icon(
                              Icons.arrow_downward,
                              color: Colors.white70,
                            );
                          },
                        )
                      ],
                    ),
                  )
                : _buildList(context)),
        Align(
          child: _buildLastOrder(context),
          alignment: Alignment.bottomLeft,
        )
      ],
    );
  }
}
