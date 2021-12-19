import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MyNotifyShape extends StatelessWidget {
  final Color color;
  final BoxShape shape;
  final Alignment alignment;
  final int counter;
  final bool isAnimated;

  MyNotifyShape(
      {this.color,
      this.shape,
      this.alignment,
      this.counter,
      this.isAnimated = false});

  Widget _buildDot(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      alignment: Alignment.center,
      child: counter == null
          ? Container()
          : Text(
              "$counter",
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70),
            ),
      decoration: BoxDecoration(
          color: color ?? greenColor, shape: shape ?? BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.topRight,
      child: isAnimated
          ? SpinKitPumpingHeart(
              itemBuilder: (context, index) {
                return _buildDot(context);
              },
              size: 25.0,
              duration: Duration(seconds: 2),
            )
          : _buildDot(context),
    );
  }
}
