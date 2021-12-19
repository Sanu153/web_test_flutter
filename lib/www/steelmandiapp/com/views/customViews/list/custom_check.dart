import 'package:flutter/material.dart';

class MyCustomCheck extends StatelessWidget {
  final IconData iconName;

  MyCustomCheck({@required this.iconName});

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconName,
      size: 30.0,
      color: Theme.of(context).primaryColorDark,
    );
//    return Container(
//      height: 30.0,
//      width: 32.0,
//      child: Center(
//        child: Icon(
//          iconName,
//          size: 30.0,
//          color: Theme.of(context).primaryColorDark,
//        ),
//      ),
//      decoration:
//          BoxDecoration(border: Border.all(color: Colors.blueGrey, width: 2.0)),
//    );
  }
}
