import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/login_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/register_form_screen.dart';

class MyBottomBar extends StatefulWidget {
  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  final double _minPadding = 8.0;

  AuthenticationBloc _authenticationBloc;

  @override
  void didChangeDependencies() {
    _authenticationBloc = Provider.of(context).fetch(AuthenticationBloc);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle t = Theme.of(context).textTheme.title.apply(
          color: Colors.white,
        );

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: RaisedButton(
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.all(_minPadding * 2),
            onPressed: _onRegister,
            child: Text(
              "REGISTER",
              style: t,
            ),
          )),
          Expanded(
              child: RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyloginScreen()));
            },
            color: secondaryColor,
            padding: EdgeInsets.all(_minPadding * 2),
            child: Text(
              "LOGIN",
              style: t,
            ),
          )),
        ],
      ),
    );
  }

  void _onRegister() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyRegisterScreen()));
  }
}
