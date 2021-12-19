import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/router/routes.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/login_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/homeViews/landscape_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/splashViews/auth_screen_maker.dart';

class Router {
//  static final routes = {
//    initialRoute: (BuildContext context) => SplashScreen(),
//  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          final AuthenticationBloc authBloc =
              Provider.of(context).fetch(AuthenticationBloc);
          return SplashScreen(authenticationBloc: authBloc);
        });
      case loginRoute:
        return MaterialPageRoute(builder: (_) => MyloginScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          final ProductBloc productBloc =
              Provider.of(context).fetch(ProductBloc);
          return MyLandScapeHomeScreen(
            productBloc: productBloc,
          );
        });
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
