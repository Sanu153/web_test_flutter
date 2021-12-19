import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MyCustomListTile extends StatelessWidget {
  final String title;

  final String subtitle;
  final String imageUrl;
  final Widget trailing;
  final Widget leading;
  final int index;
  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;

  const MyCustomListTile({this.leading,
    this.imageUrl,
    @required this.title,
      @required this.subtitle,
      @required this.trailing,
      @required this.index,
      this.subTitleTextStyle,
      this.titleTextStyle});

  Widget _buildLeading(int index) {
    return CircleAvatar(
      backgroundColor: index == 0
          ? greenColor
          : index % 2 == 0 ? Colors.redAccent : Colors.yellowAccent,
      backgroundImage: NetworkImage(
        imageUrl,
      ),
      child: imageUrl != null
          ? null
          : Icon(
        Icons.pages,
        size: 12,
      ),
      radius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildLeading(index),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$title",
                  style: titleTextStyle == null
                      ? TextStyle(fontSize: 12)
                      : titleTextStyle,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "$subtitle",
                  style: subTitleTextStyle == null
                      ? TextStyle(fontSize: 10, color: Colors.white38)
                      : subTitleTextStyle,
                )
              ],
            ),
          ),
          Align(alignment: Alignment.centerRight, child: trailing)
        ],
      ),
    );
  }
}
