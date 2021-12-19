import 'package:flutter/material.dart';

class MyCustomCircleIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;

  MyCustomCircleIconButton({@required this.onPressed, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1)),
          child: Icon(
            icon,
            size: 16,
            color: Colors.grey[50],
          ),
        ));
  }
}
