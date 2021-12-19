import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';

class MyCustomizeViews extends StatelessWidget {
  final Function onTap;
  final Function onDrawerMenu;

  final int activeIndex;

  MyCustomizeViews(
      {Key key, this.onTap, this.activeIndex = 0, this.onDrawerMenu})
      : super(key: key);

  final double minValue = 8.0;
  final double iconSize = CoreSettings.iconSize;

  Widget _buildCustomLeading(BuildContext context) {
    final t = Theme.of(context).textTheme.headline6;
    final sub = Theme.of(context).textTheme.subtitle2;

    return Container(
      padding:
          EdgeInsets.symmetric(vertical: minValue, horizontal: minValue * 0.6),
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: IconButton(
                iconSize: iconSize,
                color: iconColor,
                icon: Icon(
                  Icons.menu,
                ),
                onPressed: onDrawerMenu),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Customize",
                style: t.apply(color: Colors.white),
              ),
              Text(
                "All",
                style: sub.apply(color: Colors.white60),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context,
      {String title,
      IconData iconData,
      Function onTap,
      bool isActive = false}) {
    final theme =
        Theme.of(context).textTheme.headline6.apply(color: Colors.white70);
    return InkWell(
      splashColor: Theme.of(context).primaryColorDark,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: minValue * 2, vertical: 10),
        margin: EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: iconSize,
              color: isActive ? Colors.white : iconColor,
            ),
            SizedBox(
              width: minValue * 2,
            ),
            Text(
              "$title",
              style: theme,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
//        padding: EdgeInsets.only(left: 8),
      child: Column(
        children: <Widget>[
          _buildCustomLeading(context),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildRow(context,
                    title: "Portfolio",
                    iconData: Icons.work,
                    onTap: () => onTap(1)),
                _buildRow(context,
                    title: "Trade Book",
                    iconData: Icons.assessment,
                    onTap: () => onTap(2)),
                _buildRow(context,
                    title: "Announcement",
                    iconData: Icons.surround_sound,
                    onTap: () => onTap(3)),
                _buildRow(context,
                    title: "Support",
                    iconData: Icons.chat,
                    onTap: () => onTap(4)),
                _buildRow(context,
                    title: "More",
                    iconData: Icons.more_horiz,
                    isActive: activeIndex == 5,
                    onTap: () => onTap(5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
