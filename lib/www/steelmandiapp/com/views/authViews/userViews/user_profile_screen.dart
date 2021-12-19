import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/userViews/change_password.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/userViews/user_info.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthUser _authUser = Provider.of(context).dataManager.authUser;
    final AuthenticationBloc _authBloc =
        Provider.of(context).fetch(AuthenticationBloc);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${_authUser.user.name}'),
//                Text(
//                  'USERID-${_authUser.user.userId}',
//                  style: TextStyle(fontSize: 12.0),
//                )
              ],
            ),
            bottom: TabBar(
              indicator: BoxDecoration(
                color: Color(0xff273047),
              ),
              tabs: [
                Tab(
                  icon: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        size: 18.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'INFO',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.lock,
                        size: 18.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'PASSWORD',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UserInfo(
                authenticationBloc: _authBloc,
              ),
              PasswordChangeViews(
                authenticationBloc: _authBloc,
              )
            ],
          ),
        ),
      ),
    );
  }
}
