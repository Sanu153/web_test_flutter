//import 'package:action_cable/action_cable.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/last_trade.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_message.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/open_negotiation.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/services/socketService/channel_subscription.dart';
//
//class WebSocket {
//  ActionCable _actionCable;
//  DataManager _dataManager;
//  Subscription subscription;
//
//  static final String BUY_SELL_COUNT_CHANNEL = 'BuySellCountChannel';
//  static final String NEGOTIATION_CHANNEL = 'NegotiationChannel';
//  static final String GRAPHDATA_CHANNEL = 'LastTradedPriceChannel';
//  static final String PORTFOLIO_OPEN_CHANNEL = 'PortfolioOpenChannel';
//  static final String PORTFOLIO_CLOSE_CHANNEL = 'PortfolioClosedChannel';
//
//  WebSocket({DataManager dataManager}) {
//    _dataManager = dataManager;
////    onConnection();
//  }
//
//  void unSubscribeChanel() {
//    // Make all unsubscribe
//    _actionCable.unsubscribe(BUY_SELL_COUNT_CHANNEL);
//    _actionCable.unsubscribe(NEGOTIATION_CHANNEL);
//    _actionCable.unsubscribe(GRAPHDATA_CHANNEL);
//    _actionCable.unsubscribe(PORTFOLIO_OPEN_CHANNEL);
//    _actionCable.unsubscribe(PORTFOLIO_CLOSE_CHANNEL);
//    _actionCable.disconnect();
//    print("All Channel UnSubscribed");
//  }
//
//  void onConnection({Function onConnected, Function onFailed}) {
//    final String token = _dataManager.authenticationToken.split(' ')[1];
//    bool isConnected = false;
//    try {
//      _actionCable = ActionCable.Connect(
//          '${Endpoint.WEB_SOCKET_CONNECTION}?token=$token', onConnected: () {
//        subscription = Subscription(cable: _actionCable);
//        onConnected();
//      }, onCannotConnect: () {
//        print("Web Socket Can Not Connect");
//        onFailed("Web Socket Can Not Connect");
//      }, onConnectionLost: () {
//        print("Web Socket Connection Lost !!!");
//        onFailed("Web Socket Connection Lost !!!");
//      });
//    } catch (e) {
//      print("onError In Connection");
//      onFailed(e.toString());
////      //print(e);
//    }
//  }
//
//  void buySellCount(int productSpecId, int marketId,
//      {Function onData, Function onSubscribed}) {
//    _actionCable.subscribe(BUY_SELL_COUNT_CHANNEL,
////        channelParams: {'product_spec_id': productSpecId,"market_hierarchy_id": marketId},
//        channelParams: {'product_spec_id': productSpecId},
//        onSubscribed: () {
//          print("BuySell Subscribed");
//          onSubscribed();
//        },
//        onDisconnected: () {
//          print("****** Warning BuySELL Channel Disconnected *********");
//        },
//        onMessage: (Map data) =>
//            onData(TradeBuySellRequest.fromJson(data['data'])));
//  }
//
//  void chatNegotiation(int requestResponder,
//      {Function onData, Function onSubscribed}) {
//    _actionCable.subscribe(NEGOTIATION_CHANNEL,
//        channelParams: {'request_responder_id': requestResponder},
//        onDisconnected: () {
//          print("****** Warning NEGOTIATION_CHANNEL Disconnected *********");
//        },
//        onSubscribed: onSubscribed,
//        onMessage: (Map data) {
//          print("Negotiation Received Data: $data");
//
//          if (data.containsKey("negotiation_chat_message")) {
//            // Make Chat NegotiationMessage
//            final NegotiationMessage _message =
//                NegotiationMessage.fromJson(data['negotiation_chat_message']);
//
//            onData(_message);
//          } else if (data.containsKey("negotiation")) {
//            print("Negotiation Data: $data");
//
//            onData(Negotiation.fromJson(data['negotiation']));
//          } else if (data.containsKey('order_status')) {
//            final ApproveRejectMessage _sts = ApproveRejectMessage(
//                message: data['response_message'],
//                actionProposerId:
//                    data['user_id'] ?? _dataManager.authUser.user.userId + 1,
//                negotiationAction: data['order_status'] == 'Rejected'
//                    ? NegotiationAction.REJECT
//                    : NegotiationAction.APPROVE);
//            onData(_sts);
//          }
//        });
//  }
//
//  void getGraphDataSocket(List<int> productSpecMarket,
//      {Function onData, Function onSubscribed}) {
//    //print("ID: $productSpecMarket");
////    //print("Connection: ${_actionCable.}")
//    _actionCable.subscribe(GRAPHDATA_CHANNEL,
//        channelParams: {'product_spec_market_ids': productSpecMarket},
//        onDisconnected: () {
//          print("****** Warning GRAPHDATA_CHANNEL Disconnected *********");
//        },
//        onSubscribed: onSubscribed,
//        onMessage: (Map data) {
//          onData(LastTrade.fromJson(data));
//        });
//  }
//
//  void portfolioOPenChannel({Function onData, Function onSubscribed}) {
//    print("Portfolio Channel: $PORTFOLIO_OPEN_CHANNEL");
//    _actionCable.subscribe(PORTFOLIO_OPEN_CHANNEL,
//        channelParams: {"user_id": _dataManager.authUser.user.userId},
//        onDisconnected: () {
//      print("****** Warning PORTFOLIO_OPEN_CHANNEL Disconnected *********");
//    }, onSubscribed: () {
//      print("Portfolio Open Channel Subscribed");
//      onSubscribed();
//    }, onMessage: (Map data) {
//      print("On Portfolio Data Received: ${data}");
//      onData(OpenNegotiation.fromJson(data['portfolio_open']));
//    });
//  }
//
//  void portfolioClosedChannel({Function onData, Function onSubscribed}) {
//    _actionCable.subscribe(PORTFOLIO_CLOSE_CHANNEL,
//        channelParams: {"user_id": _dataManager.authUser.user.userId},
//        onDisconnected: () {
//      print("****** Warning PORTFOLIO_CLOSE_CHANNEL Disconnected *********");
//    }, onSubscribed: () {
//      print("Portfolio Closed Channel Subscribed");
//      onSubscribed();
//    }, onMessage: (Map data) {
//      print("On Portfolio Closed Data Received: ${data}");
//      onData(OpenNegotiation.fromJson(data['portfolio_open']));
//    });
//  }
//
//  void unSubscribeChatNegotiation() {
//    _actionCable.unsubscribe(NEGOTIATION_CHANNEL);
//  }
//}
