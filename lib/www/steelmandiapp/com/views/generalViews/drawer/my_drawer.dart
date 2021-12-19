import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/signin_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/feature_implement_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/userViews/user_profile_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/dialog/custom_alert_dialog.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/securityViews/terms_conditions.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/settingsViews/settings_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/supportChartViews/support_chat_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/historyViews/request_responders.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/splashViews/auth_screen_maker.dart';

class MyDrawer extends StatelessWidget {
  final GlobalKey globalKey;

  final Color color = Colors.white;

  MyDrawer({this.globalKey});

  void _onProfileTap(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext con) => UserProfileScreen()));
  }

  void _onSettingTap(BuildContext context) {
    Navigator.of(context).pop();
    SystemConfig.makeDevicePotrait().then((value) => Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext con) => SettingsScreen())));
  }

  void _onSupportTap(BuildContext context) {
    Navigator.of(context).pop();
    SystemConfig.makeDevicePotrait().then((value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext con) => MySupportViews())).then((value) {
          print("Back");
        }));
  }

  void _onTerms(BuildContext context) {
    Navigator.of(context).pop();
//    SystemConfig.makeDevicePotrait().then((value) => );
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext con) => TermsAndConditions()));
  }

  void _onHistory(BuildContext context) {
    final MarketBloc _mBloc = Provider.of(context).fetch(MarketBloc);
    SystemConfig.makeDevicePotrait()
        .then((value) => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RequestResponders(
                  marketBloc: _mBloc,
                ))));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc =
        Provider.of(context).fetch(AuthenticationBloc);
    final dataManager = Provider.of(context).dataManager;

    final nameStyle = Theme.of(context).textTheme.headline6.apply(color: color);
    final listText = Theme.of(context).textTheme.subtitle1.apply(color: color);

    final String imageUrl = dataManager.authUser.user.imageUrl;

    return Drawer(
      elevation: 0.0,
      child: Container(
        width: 210.0,
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: <Widget>[
//
            ListTile(
              leading: CircleAvatar(
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : AssetImage("assets/image/default_user.png"),
              ),
              onTap: () => _onProfileTap(context),
              title: Text(
                "${dataManager.authUser.user.name}",
                style: nameStyle,
              ), //,
              trailing: Icon(
                Icons.chevron_right,
                color: color,
              ),
            ),
            ListTile(
              title: Text(
                "History",
                style: listText,
              ),
              onTap: () => _onHistory(context),
              leading: Icon(
                Icons.history,
                color: color,
              ), //,
//              trailing: Icon(
//                Icons.keyboard_arrow_down,
//                color: color,
//              ),
            ),
            ListTile(
              title: Text(
                "Settings",
                style: listText,
              ),
              onTap: () => _onSettingTap(context),
              leading: Icon(
                Icons.settings,
                color: color,
              ), //,
//              trailing: Icon(
//                Icons.keyboard_arrow_down,
//                color: color,
//              ),
            ),
            ListTile(
              title: Text(
                "Support",
                style: listText,
              ),
              onTap: () => _onSupportTap(context),
              leading: Icon(
                Icons.supervised_user_circle,
                color: color,
              ), //,
            ),
            ListTile(
              title: Text(
                "Rate Us",
                style: listText,
              ),
              onTap: () => _rateUsNow(context),
              leading: Icon(
                Icons.star_border,
                color: color,
              ), //,
            ),
            ListTile(
              title: Text(
                "Logout",
                style: listText,
              ),
              onTap: () {
                loggedOut(authBloc, context);
              },
              leading: Icon(
                Icons.exit_to_app,
                color: color,
              ), //,
            ),
            ListTile(
                title: Text(
                  "Terms & Conditions",
                  style: TextStyle(color: color),
                ),
                onTap: () => _onTerms(context)),
          ],
        ),
      ),
    );
  }

  void _rateUsNow(BuildContext context) {
    Navigator.of(context).pop();
    DialogHandler.showMyCustomDialog(
        context: globalKey.currentContext,
        isBarrier: false,
        child: MyCustomAlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          minWidth: MediaQuery.of(context).size.height,
          elevation: 15,
          title: Text(
            "Rate us",
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .apply(color: Colors.white),
          ),
          content: SizedBox(
            height: 70.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Write your review",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .apply(color: Colors.white70),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  child: FeatureImplement(),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          titlePadding: EdgeInsets.only(bottom: 0, top: 8, left: 16),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(globalKey.currentContext).pop();
              },
              child: Text(
                "CLOSE",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
//            FlatButton(
//              onPressed: () {},
//              child: Text(
//                "SAVE",
//                style: TextStyle(color: Colors.white),
//              ),
//            ),
          ],
        ));
  }

  void loggedOut(AuthenticationBloc bloc, BuildContext context) async {
    Navigator.of(context).pop();

    DialogHandler.showMyCustomDialog(
        context: globalKey.currentContext,
        isBarrier: false,
        child: MyCustomAlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          minWidth: MediaQuery.of(context).size.height,
          elevation: 15,
          title: Text(
            "Logout",
            style: Theme.of(context).textTheme.title.apply(color: Colors.white),
          ),
          content: Text(
            "Are you sure? Do you want to logout?",
            style: Theme.of(context)
                .textTheme
                .subhead
                .apply(color: Colors.white70),
          ),
          titlePadding: EdgeInsets.only(bottom: 0, top: 8, left: 16),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(globalKey.currentContext).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            FlatButton(
              onPressed: () {
                _onLoggedOut(bloc);
              },
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }

  void _onLoggedOut(AuthenticationBloc bloc) async {
    //print("MyDrawer Confirm Logout Called");

    Navigator.of(globalKey.currentContext).pop();
    final SIgnInBloc sIgnInBloc =
        Provider.of(globalKey.currentContext).fetch(SIgnInBloc);

//    await bloc.logout();
    bool result = await bloc.logout();
    if (result) {
      await SystemConfig.makeDevicePotrait();
      // Closing Signin BlocStream
      sIgnInBloc.makeInitialState();
      await sIgnInBloc.disclose();
      Navigator.pushAndRemoveUntil(
          globalKey.currentContext,
          MaterialPageRoute(
              builder: (BuildContext context) => SplashScreen(
                    authenticationBloc: bloc,
                  )),
          (Route<dynamic> router) => false);
    } else {
      print("You are not logged out yet...");
    }
  }
}
