import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MyMessageBody extends StatelessWidget {
  final String message;
  final bool isMe;

  MyMessageBody({@required this.message, this.isMe});

  final double minValue = 8.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: isMe ? chatTileOne : Color(0xff001940),
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(minValue * 4),
                      bottomLeft: Radius.circular(minValue * 4),
                      topRight: Radius.circular(minValue * 4))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(minValue * 4),
                      topRight: Radius.circular(minValue * 4))),
          padding: EdgeInsets.all(minValue * 2),
          margin: isMe
              ? EdgeInsets.only(
                  left: 70.0,
                  bottom: minValue * 2,
                )
              : EdgeInsets.only(
                  right: 70.0, bottom: minValue * 2, left: minValue),
          child: Text(
            "$message",
            textAlign: isMe ? TextAlign.end : null,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
