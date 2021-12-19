import 'package:flutter/material.dart';

class MyPreferHeader extends StatelessWidget {
  double _minPadding = 8.0;

  Widget _buildHeader(BuildContext context) {
    return Container(
//      height: 80.0,
      padding: EdgeInsets.symmetric(
          horizontal: _minPadding * 2, vertical: _minPadding * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
//
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Select your \nPreferences',
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .apply(fontWeightDelta: 1, color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHeader(context);
  }
}
