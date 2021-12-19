import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/supportChat/support_chat.dart';

class MyChatTile extends StatelessWidget {
  final SupportChat chat;
  final bool isMe;

  MyChatTile({Key key, this.chat, this.isMe}) : super(key: key);

  final double minValue = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isMe
          ? EdgeInsets.only(right: 0.0, bottom: minValue * 2, left: 70.0)
          : EdgeInsets.only(right: 70.0, bottom: minValue * 2, left: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isMe
              ? Container()
              : CircleAvatar(
                  radius: minValue * 2,
                  backgroundImage: NetworkImage(chat.user.profile),
                ),
          SizedBox(
            width: minValue,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: minValue * 1.2, vertical: minValue * 0.7),
              decoration: BoxDecoration(
                  color: isMe ? chatTileOne : Color(0xff37474F),
                  borderRadius: isMe
                      ? BorderRadius.only(
                      topLeft: Radius.circular(minValue * 4),
                      bottomLeft: Radius.circular(minValue * 4),
                      topRight: Radius.circular(minValue * 4))
                      : BorderRadius.all(Radius.circular(minValue))),
              child: Column(
                crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: isMe
                        ? EdgeInsets.only(right: minValue)
                        : EdgeInsets.all(0),
                    child: Text(
                      "${isMe ? 'ME' : chat.user.name}",
                      style: TextStyle(
                          color: isMe ? Colors.white : greenColor,
                          fontSize: 10),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: minValue),
                    child: Text(
                      "${chat.text}",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Container(
                    child: chat.imagePath == null || chat.imagePath.isEmpty
                        ? Container()
                        : Image.network(
                      "${chat.imagePath}",
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MySuggestion extends StatelessWidget {
  final Suggestion suggestion;

  MySuggestion({Key key, this.suggestion}) : super(key: key);

  final double minValue = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff37474F),
          borderRadius: BorderRadius.all(Radius.circular(minValue))),
      padding: EdgeInsets.all(minValue * 2),
      margin: EdgeInsets.only(
          right: 70.0, bottom: minValue * 2, left: minValue * 5),
      child: Text(
        "${suggestion.text.toUpperCase()}",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: greenColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
