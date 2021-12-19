import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyLoaderScreen extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final Color spinnerColor;

  MyLoaderScreen (
      {this.backgroundColor, this.title = 'Loading', this.spinnerColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor ?? Colors.white ?? Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitThreeBounce(
              color: spinnerColor != null
                  ? spinnerColor
                  : Theme.of(context).primaryColor,
              duration: Duration(seconds: 3),
              size: 25,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "$title",
              style: Theme
                  .of(context)
                  .textTheme
                  .title,
            )
          ],
        ),
      ),
    );
  }
}
