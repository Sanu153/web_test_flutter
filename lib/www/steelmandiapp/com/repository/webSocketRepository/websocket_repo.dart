import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/socketService/web_socket_service.dart';

class WebSocketRepository {
  WebSocket _webSocket;
  DataManager _dataManager;

  WebSocketRepository(DataManager dataManager) {
    _dataManager = dataManager;
    _webSocket = WebSocket(dataManager: dataManager);
  }

  void connection({Function onConnected, Function onFailed}) =>
      _webSocket.onConnection(onConnected: onConnected, onFailed: onFailed);

  void unSubscribe() => _webSocket.unSubscribeChanel();

  void getBuySellCount(int productSpecId, int marketId,
          {Function onData, Function onSubscribed}) =>
      _webSocket.buySellCount(productSpecId, marketId,
          onData: onData, onSubscribed: onSubscribed);

  void negotiationChannel(int requestResponderId,
          {Function onData, Function onSubscribed}) =>
      _webSocket.chatNegotiation(requestResponderId,
          onData: onData, onSubscribed: onSubscribed);

  void graphDataChannel(List<int> ids,
      {Function onData, Function onSubscribed}) =>
      _webSocket.getGraphDataSocket(ids,
          onData: onData, onSubscribed: onSubscribed);

  void portfolioOpenRequestSocket({Function onData, Function onSubscribed}) =>
      _webSocket.portfolioOPenChannel(
          onData: onData, onSubscribed: onSubscribed);

  void portfolioClosedRequestSocket({Function onData, Function onSubscribed}) =>
      _webSocket.portfolioClosedChannel(
          onData: onData, onSubscribed: onSubscribed);

  void unSubscribeChatNegotiation() => _webSocket.unSubscribeChatNegotiation();
}
