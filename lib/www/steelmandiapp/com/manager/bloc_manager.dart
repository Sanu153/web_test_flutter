import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/register_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/signin_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/announceBloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/sidebar_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/support_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/verificationBloc/otp_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/webSocketBloc/product_socket.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/webSocketRepository/websocket_repo.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/notification_manager.dart';

class MainManager {
  Map<dynamic, dynamic> repository = {};
  final DataManager dataManager;
  final AuthenticationBloc authenticationBloc;
  WebSocketRepository webSocketRepository;

//  DataManager get dataManager =>
//      _dataManager == null ? DataManager() : _dataManager;
  final NotificationManager notificationManager;

  MainManager(
      {this.authenticationBloc, this.dataManager, this.notificationManager}) {
    webSocketRepository = WebSocketRepository(dataManager);

    /// Register All Blocs Here
    final ProductBloc productBloc = ProductBloc(dataManager: dataManager);
    final WebSocketBloc _webSocket = WebSocketBloc(
        dataManager: dataManager,
        productBloc: productBloc,
        webSocketRepository: webSocketRepository);

    final _sideBarBloc = SideBarBloc(dataManager: dataManager);

    register(
        AuthenticationBloc,
        AuthenticationBloc(
            dataManager: dataManager,
            socketRepository: webSocketRepository,
            notificationManager: notificationManager));
    register(RegisterBloc, RegisterBloc(dataManager: dataManager));
    register(SIgnInBloc, SIgnInBloc(dataManager: dataManager));
    register(ProductBloc, productBloc);
    register(OtpBloc, OtpBloc(dataManager: dataManager));
    register(
        MarketBloc,
        MarketBloc(
            notificationManager: notificationManager,
            dataManager: dataManager,
            productBloc: productBloc,
            webSocketRepository: webSocketRepository));
    register(
        GraphBloc,
        GraphBloc(
            dataManager: dataManager,
            productBloc: productBloc,
            webSocketRepository: webSocketRepository));
    register(SideBarBloc, _sideBarBloc);
    register(
        PortfolioBloc,
        PortfolioBloc(
            dataManager: dataManager,
            sideBarBloc: _sideBarBloc,
            webSocketRepository: webSocketRepository));
    register(AnnouncementBloc, AnnouncementBloc(dataManager: dataManager));
    register(WebSocketBloc, _webSocket);
    register(NotificationManager, notificationManager);
    register(
        SupportBloc,
        SupportBloc(
            webSocketRepository: webSocketRepository,
            dataManager: dataManager));
  }

  register(name, object) {
    repository[name] = object;
  }

  /// Get Bloc Components By Reference Name
  fetch(name) => repository[name];

//  getAuthData() {
//    //print("Get AUth Data");
//    //print(authModel.authToken);
//  }
}
