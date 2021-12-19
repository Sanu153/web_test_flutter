import 'package:flutter/material.dart';

class MyMessageNotifier extends StatelessWidget {
  double _minPadding = 8.0;

  final String message;
  final Function onClose;
  final Color backgroundColor;

  MyMessageNotifier (
      {this.message = 'Invalid', this.onClose, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.redAccent[700];
    return Card(
      color: backgroundColor == null ? color : backgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: _minPadding * 1.3, horizontal: _minPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                "$message",
                style: Theme
                    .of(context)
                    .textTheme
                    .subhead
                    .apply(color: Colors.white),
              ),
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor: Theme.of(context).primaryColor,
              child: onClose == null
                  ? Icon(
                Icons.not_interested,
                size: 15.0,
              )
                  : GestureDetector(
                onTap: onClose,
                child: Icon(Icons.close),
              ),
            )
          ],
        ),
      ),
    );
  }
}
