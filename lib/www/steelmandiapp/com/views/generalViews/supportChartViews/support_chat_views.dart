import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/support_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/supportChat/support_chat.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/supportChartViews/chat_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/supportChartViews/feedback_screen.dart';

class MySupportViews extends StatefulWidget {
  final Orientation orientation;

  MySupportViews({this.orientation});

  @override
  _MySupportViewsState createState() => _MySupportViewsState();
}

class _MySupportViewsState extends State<MySupportViews> {
  final double minValue = 8.0;

  Future<bool> _onBackTap(BuildContext context) async {
    SystemConfig.makeStatusBarHide();
    await SystemConfig.makeDeviceLandscape()
        .then((value) => Navigator.of(context).pop());
    return true;
  }

  void _onTap() async {
    Navigator.of(context).pop();
    final SupportBloc _sBloc = Provider.of(context).fetch(SupportBloc);
    SystemConfig.makeDevicePotrait().then((dynamic d) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MyChatScreen(
                    bloc: _sBloc,
                    user: User(
                        name: "SUPPORT",
                        mobile: "9090803061",
                        email: "something@email.com",
                        id: 32,
                        profile:
                            "https://cdn.pixabay.com/photo/2015/07/27/20/16/book-863418_960_720.jpg"),
                  )));
    });
  }

  void _onFeedBackTap() async {
    Navigator.of(context).pop();
    SystemConfig.makeStatusBarHide();
    SystemConfig.makeDevicePotrait().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (_) => FeedbackFormScreen())));
  }

  Widget _buildCustomLeading(BuildContext context) {
    final t = Theme.of(context).textTheme.headline6;
    final sub = Theme.of(context).textTheme.subtitle1;

    return AppBar(
//      padding: EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white60,
          ),
          onPressed: () => _onBackTap(context)),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Support",
            style: t.apply(color: Colors.white),
          ),
          Text(
            "All",
            style: sub.apply(color: Colors.white60),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
            color: Colors.white70,
            icon: Icon(Icons.fullscreen),
            onPressed: () async {
              SystemConfig.makeDevicePotrait().then((dynamic d) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Container()));
              });
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context)
        .textTheme
        .subtitle2
        .apply(color: Colors.white, fontWeightDelta: 1);

    return WillPopScope(
      onWillPop: () => _onBackTap(context),
      child: Scaffold(
        appBar: _buildCustomLeading(context),
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//          _buildCustomLeading(context),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/image/default_user.png"),
                    ),
                    title: Text(
                      "Raise an issue",
                      style: theme,
                    ),
                    subtitle: Text(
                      "Any question? Feel free to ask",
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () => _onTap(),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.yellowAccent,
                      ),
//                    backgroundImage:
//                        AssetImage("assets/image/default_user.png"),
                    ),
                    title: Text(
                      "Suggest an Idea",
                      style: theme,
                    ),
                    subtitle: Text(
                      "Please leave your feedback here",
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () => _onFeedBackTap(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
