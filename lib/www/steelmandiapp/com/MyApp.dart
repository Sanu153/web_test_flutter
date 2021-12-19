import 'package:flutter/material.dart' hide Router;
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/dark_theme.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/router/router.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/router/routes.dart';

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: CoreSettings.appName,
      theme: darkTheme,
//      routes: Router.routes,
      initialRoute: initialRoute,
      onGenerateRoute: Router.generateRoute,
    );
  }
}
