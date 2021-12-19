import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/supportChat/support_chat.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/observer.dart';

class MyChatListBuilder extends StatelessWidget {
  final Stream stream;
  final Function builder;

  MyChatListBuilder({Key key, this.stream, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer<List<SupportItem>>(
      stream: stream,
      onSuccess: (context, List<SupportItem> data) {
        return builder(context, data);
      },
    );
  }
}
