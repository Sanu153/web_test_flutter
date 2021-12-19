import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/webSocketRepository/websocket_repo.dart';

class WebSocketBloc {
  final ProductBloc productBloc;
  final DataManager dataManager;
  final WebSocketRepository webSocketRepository;

  WebSocketBloc({this.productBloc, this.dataManager, this.webSocketRepository});

  void connect({Function onConnected, Function onFailed}) => webSocketRepository
      .connection(onConnected: onConnected, onFailed: onFailed);

  void subscribe() {
    buySellCount();
  }

  void unSubscribe() {
    webSocketRepository.unSubscribe();
  }

  void onChangeProduct() {
    // On Product Changed, UnSubscribe All Previous Subscription
    // Subscribe Latest Tab
//    unSubscribe();
//    subscribe();
  }

  void buySellCount() {
    print("BuySell Subscribed Called On Product Change");
    int productSpecId = productBloc.getCurrentUserProduct.productSpecId;
    int marketId = 0;
    webSocketRepository.getBuySellCount(productSpecId, marketId,
        onSubscribed: () {
      ////print("Subscribe To: $productSpecId");
    }, onData: (TradeBuySellRequest data) {
      // Dont Update Stream If User is HimSelf/HerSelf Created The Buy?Sell Request;
      // ByDefault Through RestAPI Count is being updated.
      if (dataManager.authUser.user.userId == data.userId) return;
      try {
        final UserProduct current = productBloc.getCurrentUserProduct;
        current.productSpecMarketList.forEach((key, List value) {
          if (value[1] == data.marketHierarchyId) {
            // value = [OMC Gandhamardhan, 224]
            ////print("Incremented To One");
            if (data.buySell == 'Buy') {
              current.counter.buyRequestCount++;
            } else {
              current.counter.sellRequestCount++;
            }
            productBloc.updateDataFieldToCurrentProduct(current);
          }
        });
      } catch (e) {
        ////print("Error In BuySellCount Channel: ${e.toString()}");
        ////print(e);
      }
    });
  }
}
