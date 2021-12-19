import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MySideBarIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Function onIconTap;

  MySideBarIconButton({this.icon, this.isSelected = false, this.onIconTap});

  final double iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
//    print("Is Selected: $isSelected");
    return Material(
      color: Colors.transparent,
      child: IconButton(
          padding: EdgeInsets.all(5),
          iconSize: iconSize,
          hoverColor: Colors.red,
          color: isSelected ? iconActiveColor : iconColor,
          icon: Icon(
            icon,
          ),
          onPressed: onIconTap),
    );
  }
}
