import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/sidebarViews/sidebar_screen.dart';

class SideBarWidget extends StatelessWidget {
  final Widget child;
  final bool hasMore;

  SideBarWidget({Key key, this.child, this.hasMore = false})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        hasMore ? Container() : MySidebarScreen(),
        Expanded(child: child)
      ],
    );
  }
}
