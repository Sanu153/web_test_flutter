import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyComponentsLoader extends StatelessWidget {
  final Color color;

  MyComponentsLoader ({this.color});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? Colors.blueGrey[700],
      size: 25,
      duration: Duration(seconds: 2),
    );
  }
}
