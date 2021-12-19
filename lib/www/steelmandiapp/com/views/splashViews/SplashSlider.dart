import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MySplashSliderComponents extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  MySplashSliderComponents ({this.icon, this.subtitle, this.title, this.child});

  final double iconSize = 85;
  final Color _iconColor = Colors.white;

  final double _minPadding = 8.0;

  Widget _buildLodo() {
    return CircleAvatar(
      backgroundColor: accentColor,
      radius: 55,
      child: Icon(
        icon,
        size: iconSize,
        color: _iconColor,
      ),
    );
  }

  Widget _buildImageLogo () {
    return child;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _title =
        Theme.of(context).textTheme.display1.apply(color: Colors.white);
    TextStyle _subtitle =
    Theme
        .of(context)
        .textTheme
        .title
        .apply(color: secondaryColor);
    final double _size = MediaQuery.of(context).size.width;
    return Container(
      width: _size / 3,
      margin: EdgeInsets.all(_minPadding * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          child == null ? _buildLodo() : _buildImageLogo(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: _minPadding * 3),
            child: Text(
              title,
              style: _title,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: _minPadding * 4),
            child:
            Text(subtitle, style: _subtitle, textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}
