import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/sidebar_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/footerViews/bottom_settings_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/footerViews/my_time_frame.dart';

class MyBottomNavigation extends StatelessWidget {
  Widget _buildCurrentDate(BuildContext context) {
    final SideBarBloc _sideBloc = Provider.of(context).fetch(SideBarBloc);

    return StreamBuilder<String>(
        stream: _sideBloc.currentDateTime$,
        initialData: DateTime.now().toLocal().toString(),
        builder: (context, snapshot) {
//        "30 Sep 13:15:45",
//      //print("${DateTime.now().toLocal()}");
          return Text(
            "${snapshot.data}",
            style: TextStyle(color: Colors.white54, fontSize: 12.0),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final DataManager settings = Provider
        .of(context)
        .dataManager;

    return Container(
      color: Theme
          .of(context)
          .primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          MyBottomIconSettings(),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight, child: MyTimeFrame())),
          Container(
            width: settings.coreSettings.selectedMarketSize,
            padding: EdgeInsets.only(right: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildCurrentDate(context),
            ),
          )
        ],
      ),
    );
  }
}
