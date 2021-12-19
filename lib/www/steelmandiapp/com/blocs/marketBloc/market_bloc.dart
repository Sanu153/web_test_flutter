import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/market_grouping.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/schedule.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/productRepository/product_repository.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/tradeRepository/trade_repository.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/webSocketRepository/websocket_repo.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/notification_manager.dart';

class MarketBloc {
  final DataManager dataManager;
  ProductRepository _productRepository;
  TradeRepository _tradeRepository;
  ProductBloc _productBloc;
  final WebSocketRepository webSocketRepository;
  final NotificationManager notificationManager;

  MarketBloc(
      {this.dataManager,
      ProductBloc productBloc,
      this.webSocketRepository,
      this.notificationManager}) {
    _productBloc = productBloc;
    _productRepository = ProductRepository(dataManager);
    _tradeRepository = TradeRepository(dataManager);
    _productBloc.currentActiveUserProductSubject.listen((UserProduct up) {
      subscribeToBuySellCount();
    });
  }

  // Subjects ******************************************************************
  BehaviorSubject<ActionState> _actionStateSubject =
      BehaviorSubject<ActionState>.seeded(ActionState.INITIAL);
  BehaviorSubject<Failure> _failedSubject =
      BehaviorSubject<Failure>.seeded(null);
  BehaviorSubject<List<MarketGrouping>> _marketGroupingSubject =
      BehaviorSubject<List<MarketGrouping>>();
  BehaviorSubject<List<Object>> _buySellSubject =
      BehaviorSubject<List<Object>>.seeded(null);
  BehaviorSubject<List<dynamic>> _buySellRequestRespondSubject =
      BehaviorSubject<List<dynamic>>.seeded(null);

  BehaviorSubject<bool> _saveButtonVisibleSubject =
      BehaviorSubject<bool>.seeded(false);

//  // BuySellRequest Count
//  final BehaviorSubject<BuySellCount> _buySellRequestCounterSubject =
//      BehaviorSubject<BuySellCount>();

  ///// DISPOSE //////
  void dispose() {
//    _marketGroupingSubject.close();
//    _buySellSubject.close();
//    _saveButtonVisibleSubject.close();
//    _buySellRequestRespondSubject.close();
//
//    ////print("BuySell Streams Closed-------!!!");
  }

  /// Streams*******************************************************************
  Observable<ActionState> get _actionState$ => _actionStateSubject.stream;

  Observable<Failure> get _onFailure$ => _failedSubject.stream;

  Observable<bool> get shouldVisibleSaveButton$ =>
      _saveButtonVisibleSubject.stream;

  Observable<List<MarketGrouping>> get getMarketGrouping$ =>
      _marketGroupingSubject.stream;

  Observable<List<Object>> get getBuySellSuccesData$ => _buySellSubject.stream;

  Observable<List<dynamic>> get _getBuySellRequestRespond$ =>
      _buySellRequestRespondSubject.stream;

//  Observable<BuySellCount> get buySellRequestCounter$ =>
//      _buySellRequestCounterSubject.stream;

  // Combined Streams **********************************************************
  Observable<Map<dynamic, dynamic>> get buySellRequestResponder$ =>
      Observable.combineLatest3(
          _actionState$,
          _onFailure$,
          _getBuySellRequestRespond$,
          (ActionState state, Failure failure, List result) =>
              {ActionState: state, Failure: failure, List: result});

  Observable<Map<dynamic, dynamic>> get buySellRequest$ =>
      Observable.combineLatest3(
          _actionState$,
          _onFailure$,
          getBuySellSuccesData$,
          (ActionState state, Failure failure, List<Object> groupingL) =>
              {ActionState: state, Failure: failure, List: groupingL});

  Observable<Map<dynamic, dynamic>> get userSpecMarketState$ =>
      Observable.combineLatest3(
          _actionState$,
          _onFailure$,
          getMarketGrouping$,
          (ActionState state, Failure failure,
                  List<MarketGrouping> groupingL) =>
              {
                ActionState: state,
                Failure: failure,
                MarketGrouping: groupingL
              });

  ActionState get actionState => _actionStateSubject.value;

  /// Handlers
  ///
  void shouldVisibleSaveButton() {
    if (dataManager.mapMarketIdWithName != null &&
        dataManager.mapMarketIdWithName.length != 0) {
      _saveButtonVisibleSubject.sink.add(true);
    } else {
      _saveButtonVisibleSubject.sink.add(true);
    }
  }

  void makeInitial() {
    _actionStateSubject.sink.add(ActionState.INITIAL);
  }

  void _updateCurrentCounter(BuySellCount count) {
    final UserProduct up = _productBloc.getCurrentUserProduct;

    up.counter = count;
    _productBloc.updateDataFieldToCurrentProduct(up);
  }

  /// API SERVICE ///

  Future<bool> setAlert(
      {int marketId, String validity, double price, int productSpecId}) async {
    try {
      final ResponseResult result = await _tradeRepository.setAlert(
          marketId: marketId,
          validity: validity,
          price: price,
          productSpecId: productSpecId);

      if (result.data is Failure) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  // Submit A BuySell Request
  Future<void> onSubmitBuySellRequest(
      {String type,
      int productSpecId,
      double price,
      int marketHId,
      double quantity,
      String place,
      String customRequirements,
      int validity}) async {
    ////print("Market Bloc Get Request Called: ");
    final Map<String, dynamic> _dataSet = {
      "product_spec_id": productSpecId,
      "buy_sell": type,
      "price_per_unit": price,
      "quantity": "$quantity",
      "market_hierarchy_id": marketHId,
      "validity": validity,
      "custom_requirements": customRequirements ?? '',
      "place": place,
    };
    _actionStateSubject.sink.add(ActionState.LOADER);
    final ResponseResult _reponseResult =
        await _tradeRepository.onBuySellRequestSubmit(_dataSet);
    if (_reponseResult.data is Success) {
      _actionStateSubject.sink.add(ActionState.SUCCESS);
      _buySellSubject.sink.add(_reponseResult.data.data);
      _failedSubject.add(null);
      //print(_reponseResult.data.data);

      // List=[ResponseFlag, BuySellCounter]
      final List datSet = _reponseResult.data.data;
      final ResponseFlags _flag = datSet[0];
      final BuySellCount _count = datSet[1];
      // Dont Update Stream If User is HimSelf/HerSelf Created The Buy?Sell Request;
      // ByDefault Through Socket Count is being updated.
//      _updateCurrentCounter(_count);
    } else if (_reponseResult.data is Failure) {
      _failedSubject.sink.add(_reponseResult.data);
      _actionStateSubject.sink.add(ActionState.FAILED);
      _buySellSubject.sink.add(null);
    }
  }

  /// Get Market List With Spec Id
  Future<ResponseResult> getAddProductSpecMarket(int id) async {
    //print("Market Bloc Get Spec Called With Id $id");
    _actionStateSubject.sink.add(ActionState.LOADER);
    final ResponseResult _reponseResult =
        await _productRepository.getProductSpecMarkets(id, isAdd: true);

    if (_reponseResult.data is Success) {
      //print('Success');
      _actionStateSubject.sink.add(ActionState.SUCCESS);
      _marketGroupingSubject.sink.add(_reponseResult.data.data);
      _failedSubject.add(null);
    } else if (_reponseResult.data is Failure) {
      //print('Failure');

      _failedSubject.sink.add(_reponseResult.data);
      _actionStateSubject.sink.add(ActionState.FAILED);
      _marketGroupingSubject.sink.add(null);
    }

    return _reponseResult;
  }

  /// Get TradeRequest
  Future<ResponseResult> getTradeBuySellRequest(bool isBuy) async {
    int specId = _productBloc.getCurrentUserProduct.productSpecId;
    List<int> _marketIds =
        _productBloc.getCurrentUserProduct.productSpecMarketList.keys.toList();
    final ResponseResult _reponseResult = await _tradeRepository
        .getTradeBuySellRequest(specId, isBuy, _marketIds);
    if (_reponseResult.data is Success) {
      // Update Counter
      List _dataSet = _reponseResult.data.data;
      TradeRequest _tradeRequest = _dataSet[0];
      _updateCurrentCounter(_tradeRequest.counter);

      // Seggreagate List Into
//      final List<TradeBuySellRequest> _buySellReqList =
//          _tradeRequest.tradeBuySellRequest;
    }

    return _reponseResult;
  }

  /// Make First Respond To Request
  Future<ResponseResult> getTradeBuySellRespond(RespondNegotiation data) async {
    _actionStateSubject.add(ActionState.LOADER);
    final ResponseResult _reponseResult =
        await _tradeRepository.getTradeBuySellRespond(data);

    if (_reponseResult.data is Success) {
      _actionStateSubject.sink.add(ActionState.SUCCESS);
      _buySellRequestRespondSubject.sink.add(_reponseResult.data.data);
      _failedSubject.add(null);

      ////print(_reponseResult.data.data);
    } else if (_reponseResult.data is Failure) {
      _failedSubject.sink.add(_reponseResult.data);
      _actionStateSubject.sink.add(ActionState.FAILED);
      _buySellRequestRespondSubject.sink.add(null);
    }

    return _reponseResult;
  }

  /// Get ProductInfo Market Info
  Future<ResponseResult> getProductAndMarket(
      {int specId, int specMarketId}) async {
    int _specId;
    List<int> _marketSpecList = [];
    ////print("Data From: $specMarketId, $specId");
    if (specId != null) {
      //  {int specId, int specMarketId} This Data WIll
      //  Catch when a user from ADD Product Screen taps market info button otherwise null;
      _specId = specId;
      _marketSpecList.add(specMarketId);
    } else {
      //  This Data WIll
      //  Catch when a user from Dashboard Screen and  taps product  info button and
      //  user will see selected active product's the information;
      final current = _productBloc.getCurrentUserProduct;
      _marketSpecList = current.productSpecMarketList.keys.toList();
      _specId = current.productSpecId;
    }

    return await _tradeRepository.getProductAndMarketInfo(
        marketIds: _marketSpecList, specId: _specId);
  }

  Future<bool> subscribeToMarket(int marketSpecId, bool type) async {
    ////print(type);
    bool isSuccess = false;
    ResponseResult _result = await _tradeRepository.marketSubscription(
        isSubscribe: type, specMarketId: marketSpecId);
    if (_result.data is Failure) {
      isSuccess = false;
    } else {
      isSuccess = true;
    }
    return isSuccess;
  }

  // BuySellCount Socket
  void subscribeToBuySellCount() {
    print(
        "Subscription For BuySellCount Called*******************************");
    try {
      int productSpecId = _productBloc.getCurrentUserProduct.productSpecId;
      int marketId = 0; // Test Market Subscription ID
      webSocketRepository.getBuySellCount(productSpecId, marketId,
          onSubscribed: () {
        print("Subscribed To BuySellCount: $productSpecId");
      }, onData: (TradeBuySellRequest data) {
        print("BuySell Socket Info Received: ${data.buySell}");
        final UserProduct current = _productBloc.getCurrentUserProduct;

        final BuySellCount _currentCounter = _productBloc.currentBuySellCount;
        current.productSpecMarketList.forEach((key, List value) {
          if (value[1] == data.marketHierarchyId) {
            // value = [OMC Gandhamardhan, 224]
            ////print("Incremented To One");
            if (data.buySell == 'Buy') {
              current.counter.buyRequestCount++;
//              _currentCounter.buyRequestCount++;
            } else {
              current.counter.sellRequestCount++;
            }
            _productBloc.updateDataFieldToCurrentProduct(current);
            // Handle Local Notification
            if (dataManager.authUser.user.userId != data.userId) {
              //print("Coming************************");
              // If Creator is not me

              String _marketName = value[0];
              String product = current.productSpecName;
//              notificationManager.showNotification({
//                "data": "$data",
//                "notification": {
//                  "title":
//                      "${data.buySell} request raised in $_marketName for $product",
//                  "body":
//                      "Request has raised with price: ${data.price}, quantity: ${data.quantity}${data.tradeUnit.shortName} for delivering ${data.place} "
//                }
//              });
            }
          }
        });
      });
    } catch (e) {
      //print("Error In BuySellCount Channel Subscription: ${e.toString()}");
      //print(e);
    }
  }

  // Get TradeContract
  Future<ResponseResult> getTradeContracts() =>
      _tradeRepository.getTradeContracts();

  // Get Trade Book Schedule
  Future<ResponseResult> getTradeBookSchedule() =>
      _tradeRepository.getTradeBookSchedule();

  // Get Trade Request Responders List
  Future<ResponseResult> getTradeRequestResponders() =>
      _tradeRepository.getTradeRequestResponders();

  // Post Contract Adherence
  Future<ResponseResult> postAdherence(Map<String, dynamic> data) =>
      _tradeRepository.postAdherence(data);

  // Get Adherence
  Future<ResponseResult> getAdherence(int id) {
    print("Id: $id");
    return _tradeRepository.getAdherence(id);
  }

  // Update Schedule
  Future<ResponseResult> updateSchedule(
      {List<Schedule> schedules, int orderId}) {
    final List<Map<String, dynamic>> _scheduleMap =
        List<Map<String, dynamic>>();
    schedules.forEach((element) {
      _scheduleMap.add({
        "id": element.id.toString(),
        "payment": element.payment,
        "delivery": element.delivery
      });
    });

    final _dataSet = {"order_id": orderId, "schedules": _scheduleMap};

    return _tradeRepository.updateSchedule(_dataSet);
  }
}
