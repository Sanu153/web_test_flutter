import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyAnnotation extends StatelessWidget {
  final String data;

  final Color color;
  final bool hasSnakeDot;

  MyAnnotation({@required this.data, this.color, this.hasSnakeDot = false});

  final double minValue = 8.0;

  @override
  Widget build(BuildContext context) {
    return hasSnakeDot
        ? SpinKitPumpingHeart(
//              color: color,
            itemBuilder: (context, index) {
              return Container(
                height: 6,
                width: 6,
//                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              );
            },
            size: 25,
            duration: Duration(seconds: 5),
          )
        : Container(
            decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                border: Border.all(color: color ?? Colors.white70),
                borderRadius: BorderRadius.all(Radius.circular(minValue))),
            child: Text(
              '$data',
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
            padding: EdgeInsets.all(2),
          );
    return Container(
      width: 150.0,
//      color: Colors.red,
      child: Row(
        children: <Widget>[
          Dash(
              direction: Axis.horizontal,
              dashBorderRadius: 0,
              length: 70,
              dashLength: 6,
              dashColor: color ?? Colors.white70),
          Container(
            decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                border: Border.all(color: color ?? Colors.white70),
                borderRadius: BorderRadius.all(Radius.circular(minValue))),
            child: Text(
              '$data',
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
            padding: EdgeInsets.all(2),
          )
        ],
      ),
    );
  }
}
