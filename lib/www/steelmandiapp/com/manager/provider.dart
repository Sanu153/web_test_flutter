import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/bloc_manager.dart';

class Provider extends InheritedWidget {
  final MainManager data;

//  final DataManager dataManager;

  Provider({Key key, Widget child, this.data}) : super(key: key, child: child);

  static MainManager of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).data;
  }

//  static DataManager dm(BuildContext context) {
//    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
//        .dataManager;
//  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
//
