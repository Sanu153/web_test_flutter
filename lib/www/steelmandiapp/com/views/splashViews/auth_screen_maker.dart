import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/AuthenticateState.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/notification_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/verify/otp_verification.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/preference_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/homeViews/landscape_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/observer.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/splashViews/slider_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/splashViews/splash_screen.dart';

class SplashScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  SplashScreen({@required this.authenticationBloc});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
//  final double _minPadding = 8.0;
  AuthenticationBloc _authenticationBloc;
  ProductBloc productBloc;
  NotificationManager notificationManager;

  // Local Notifications

  void _onCreate() async {
    //print("AuthScreen OnCreated Called");
    _authenticationBloc.autoAuthenticate();
  }

  void _notifier() async {
//    await notificationManager.configure();

    // Local Notification
//    final LocalNotification _locale = LocalNotification();
//    _locale.showNotificationWithDeafultSound();
  }

  @override
  initState() {
    super.initState();
    _authenticationBloc = widget.authenticationBloc;
    _onCreate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    productBloc = Provider.of(context).fetch(ProductBloc);
    notificationManager = Provider.of(context).fetch(NotificationManager);
    _notifier();
  }

  @override
  dispose() {
//    _authenticationBloc.dispose();
//    //print("Authentication Closed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SplashViews();
    return SafeArea(
        child: Scaffold(
//      body: SliderScreen(),
      body: Observer<AuthenticationState>(
        stream: _authenticationBloc.authenticate$,
        onWaiting: (context) {
          return child;
        },
        onSuccess: (context, AuthenticationState data) {
          //print("AuthData State: ${data.authenticated}");
          if (data.authenticated ==
              AuthenticationState.initial().authenticated) {
            SystemConfig.makeDevicePotrait();
            return SplashViews();
          } else if (data.authenticated ==
              AuthenticationState.failed().authenticated) {
            SystemConfig.makeStatusBarVisible();
            SystemConfig.makeDevicePotrait();

            return SliderScreen();
          } else if (data.authenticated ==
              AuthenticationState.newUser().authenticated) {
            // User New
            return MyprefernceScreen(wilExit: true);
          } else if (data.authenticated ==
              AuthenticationState.notApproved().authenticated) {
            return MyOTPVerifyScreen(
              data: _authenticationBloc.dataManager.authUser.user.email,
              notifierType: "email",
              notifierMessage:
                  "You have to confirm your email address before continuing.",
              visibleNotifier: true,
            );
          } else if (data.authenticated ==
              AuthenticationState.signedOut().authenticated) {
            return SliderScreen();
          } else {
            SystemConfig.makeStatusBarHide();

            return MyLandScapeHomeScreen(
              productBloc: productBloc,
            );
          }
        },
      ),
    ));
  }
}
