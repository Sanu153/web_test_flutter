import 'package:flutter/material.dart';

class MyMarketAnalysis extends StatelessWidget {
  final double minValue = 8.0;

  Widget _buildCustomLeading(BuildContext context) {
    final t = Theme.of(context).textTheme.title;
    final sub = Theme.of(context).textTheme.subtitle;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Market Analysis",
            style: t.apply(color: Colors.white),
          ),
          Text(
            "All",
            style: sub.apply(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[_buildCustomLeading(context)],
      ),
    );
  }
}
