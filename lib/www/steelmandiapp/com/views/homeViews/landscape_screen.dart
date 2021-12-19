import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/webSocketBloc/product_socket.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/responsive_size.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/dashboardViews/dashboard_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/drawer/my_drawer.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/sidebarViews/sidebar_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/splashViews/splash_screen.dart';

class MyLandScapeHomeScreen extends StatefulWidget {
  final ProductBloc productBloc;

  /// If products => null, User must choose default case..

  MyLandScapeHomeScreen({@required this.productBloc});

  @override
  _MyLandScapeHomeScreenState createState() => _MyLandScapeHomeScreenState();
}

class _MyLandScapeHomeScreenState extends State<MyLandScapeHomeScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProductBloc _productBloc;
  WebSocketBloc webSocket;
  PortfolioBloc _portfolioBloc;
  MarketBloc _marketBloc;

  bool _hasDisconnected =
      false; // When App will be Paused/Sleep hasDisconnected = true

  void _onCreated() async {
    await SystemConfig.makeStatusBarHide();

    await SystemConfig.makeDeviceLandscape();

    // Initializing Product Section
    await _productBloc.getInitialProduct();
  }

  void _subscribeChannel() {
    _marketBloc.subscribeToBuySellCount();
    _portfolioBloc.portFolioOpenClosedSocket();
  }

  void onSocket() async {
    print("Web Socket Called");
    try {
      webSocket.connect(onConnected: () {
        print("Connected");
        _subscribeChannel();
        _hasDisconnected = false;
      }, onFailed: (String error) {
        print("Error To Establish Connection: $error");
      });
    } catch (e) {
      print("Error Caught In Websocket: ${e.toString()}");
    }
  }

  void _makeRotation() {
    SystemConfig.makeDeviceLandscape();
    SystemConfig.makeStatusBarHide();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _productBloc = widget.productBloc;
    _onCreated();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    print("Application State: $state");

    if (state == AppLifecycleState.paused) {
      webSocket.unSubscribe();
      _hasDisconnected = true;
    }
    if (state == AppLifecycleState.resumed) {
      if (!_hasDisconnected) return;

      _makeRotation();
      onSocket();
    }
  }

  @override
  void didChangeDependencies() {
    webSocket = Provider.of(context).fetch(WebSocketBloc);
    _portfolioBloc = Provider.of(context).fetch(PortfolioBloc);
    _marketBloc = Provider.of(context).fetch(MarketBloc);
    onSocket();
    _makeRotation();
    super.didChangeDependencies();
  }

  double _animatedHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    _makeRotation();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      drawer: MyDrawer(
        globalKey: scaffoldKey,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation or) {
          //print("Orientation In HomeScreen: $or");
          if (or == Orientation.portrait) return SplashViews();
          ResponsiveSize().initSize(context);
          SystemConfig.makeStatusBarHide();
          SystemConfig.makeDeviceLandscape();
          //print("Orientation In HomeScreen2: $or");

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              MySidebarScreen(),
              Expanded(child: MyDashboardScreen())
            ],
          );
        },
      ),
    );
  }
}
