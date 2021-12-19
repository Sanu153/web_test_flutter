import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/MyApp.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/syncfusion_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/bloc_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Need To Initialize Flutter Binding => After Upgrade to 1.12, You will need To Initialize
  Syncfusion.init();
//  await SystemConfig.setStatusBarColor();

  final DataManager dataManager = DataManager();
  final NotificationManager notificationManager = NotificationManager();
  await notificationManager.configure();

  final AuthenticationBloc authenticationBloc = AuthenticationBloc(
      dataManager: dataManager, notificationManager: notificationManager);
//  await authenticationBloc.autoAuthenticate();
  final MainManager mainManager = MainManager(
      dataManager: dataManager,
      authenticationBloc: authenticationBloc,
      notificationManager: notificationManager);

  runApp(Provider(
    data: mainManager,
    child: MyApp(),
  ));
}
