import 'package:flutter/material.dart';

class UnAuthenticateAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool willExit;
  final Function onBack;

  UnAuthenticateAppbar(
      {@required this.title, this.willExit = false, this.onBack});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return AppBar(
//      leading: Container(),
//      leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//            color: color,
//          ),
//          onPressed: onBack ??
//              () async {
//                Navigator.of(context).pop();
////            if (willExit) {
////              exit(0);
////            }
//              }),
      elevation: 0,
      title: Text(
        "$title",
        style: TextStyle(color: color),
      ),
      backgroundColor: Colors.white30,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
