import 'package:flutter/material.dart';

class MyProductHeader extends StatelessWidget {
  final Widget child;

  MyProductHeader({@required this.child});

  double _minValue = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: _minValue, right: _minValue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
//            IconButton(
//                icon: Icon(
//                  Icons.search,
//                  color: Colors.white,
//                ),
//                onPressed: _onSearch),
            child
          ],
        ),
      ),
    );
  }

  void _onSearch() {}
}
