import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/annotation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/last_trade.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_spec_market_grapph.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/user_graph_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/webSocketRepository/websocket_repo.dart';

class GraphBloc {
  final DataManager dataManager;
  final ProductBloc productBloc;
  final WebSocketRepository webSocketRepository;
  final BehaviorSubject<Map<Object, Object>> _userProductGraphSubject =
      BehaviorSubject<Map<Object, Object>>();
  final BehaviorSubject<GraphSettings> _userProductGraphSettingsSubject =
      BehaviorSubject<GraphSettings>.seeded(GraphSettings());
  final List<dynamic> _annotation = List<dynamic>();

  GraphBloc({this.dataManager, this.productBloc, this.webSocketRepository});

  // Get Current Market Graph Live Data
  final BehaviorSubject<GraphData> _selectedGraphDataSubject =
      BehaviorSubject<GraphData>();

  /// Getters
  List<dynamic> get getAnnotations => _annotation;

//  // Get Current Market Graph Live Data
//  final BehaviorSubject<GraphData> _graphAnnotationStreamSubject =
//  BehaviorSubject<GraphData>();

  Observable<Map<Object, Object>> get getUserGraph$ =>
      _userProductGraphSubject.stream;

  Observable<GraphSettings> get graphSettings =>
      _userProductGraphSettingsSubject.stream;

  // Current Market Stream Live Data
  Observable<GraphData> get currentSelectedMarketGraph$ =>
      _selectedGraphDataSubject.stream;

  UserGraph get userGraph {
    UserGraph userGraph;
    final gData = _userProductGraphSubject.value;
    if (gData != null) {
      userGraph = gData[UserGraph];
    }
    return userGraph;
  }

  // Update Current MarketGraphPrice when User Selected A Market To Make BuySell Request
  void selectedMarket(int marketId) {
    if (marketId == null)
      return; // Dont Listen Until Unless User doesn't select any market
    _userProductGraphSubject.listen((Map<Object, Object> data) {
      final UserGraph userGraph = data[UserGraph];
      if (userGraph == null) return;
      final List<ProductSpecMarket> _specList = userGraph.productSpecMarket;
//      _specList.map(f)
      _specList.forEach((ProductSpecMarket specMarket) {
        if (specMarket.graphData == null)
          return; // Return If There is No Graph Points
        if (specMarket.marketHierarchyId == marketId) {
          final GraphData lastUpdatedData = specMarket.graphData.first;
          _selectedGraphDataSubject.sink.add(lastUpdatedData);
        }
      });
    });
  }

  void pullGraphSettings() async {}

  void onGraphTypeChange() async {}

  // Get MarketIds from Current Selected ProductSpec
  List<int> get _currentMarketIds =>
      productBloc.getCurrentUserProduct.productSpecMarketList.keys.toList();

  void _updateGraphStream(ActionState state, Failure failure, UserGraph graph) {
    final Map<Object, Object> _initMap = {};
    _initMap[ActionState] = state;
    _initMap[Failure] = failure;
    _initMap[UserGraph] = graph;

    _userProductGraphSubject.sink.add(_initMap);
  }

  /// Get Graph Data info with Corresponding Product and ProductSpec
  Future<void> getProductSpecMarketGraph() async {
    int graphPointStatus = 0; // if 0 => Points Found Else => 1
    try {
      final Map<Object, Object> _initMap = {};

      ////print("Graph Data Called: $_currentMarketIds");
      if (productBloc.getCurrentUserProduct == null) {
        _updateGraphStream(ActionState.ERROR, null, null);
      }

      _updateGraphStream(ActionState.LOADER, null, null);
      int specId = productBloc.getCurrentUserProduct.productSpecId;

      final ResponseResult _result = await productBloc.getRepository
          .getProductSpecMarketGraph(specId, _currentMarketIds);
      if (_result.data is Failure) {
        _updateGraphStream(ActionState.FAILED, _result.data, null);
      } else if (_result.data is List) {
        //print("Success Data");

        /// Retrieving Data from List[Instance of 'Product', [Instance of 'ProductSpecMarket'], Instance of 'BuySellCount', List<Annotation>]
        final List<dynamic> _dataSet = _result.data;
        final Product _product = _dataSet[0];
        final List<ProductSpecMarket> _specMarketList = _dataSet[1];
        final BuySellCount _counter = _dataSet[2];
        final List<dynamic> _buySellAnnotation = _dataSet[3];

        final up = productBloc.getCurrentUserProduct;
        up.counter = _counter;
        productBloc.updateDataFieldToCurrentProduct(up);
        // Update BuySell Counter To Stream
//        productBloc.updateBuySellCounter(_counter);

        // There is Only One ProductSpec in List But ProductSpecMarket will be Multiple
//      final ProductSpec _spec = _product.productSpecs[0];

        // Update To Current Active Product
        productBloc.updateCurrentSelectedProduct(_product);

        // Update Graph Annotation
        _annotation.clear();
        // Make Latest Price Annotation
        _specMarketList.forEach((ProductSpecMarket specMarket) {
          //print("GraphBloc: Checking Graph Points: ${specMarket.graphData}");
          if (specMarket.graphData == null) {
            graphPointStatus = 1; // No Graph Data Points
            return;
          }
          // Get First Point For SnakeHead Annotation
//          final int length = specMarket.graphData.length;
          final Annotation _an = Annotation(
            annotationType: AnnotationType.CurrentMarketPrice,
            dateTime: specMarket.graphData[0].dateTime,
            price: specMarket.graphData[0].price,
          );
          _annotation.add(_an);

          // Test
          print("Last Point: ${specMarket.graphData.last.price}");
        });
        if (graphPointStatus == 1) {
          // No Graph Point
          _updateGraphStream(ActionState.FAILED,
              Failure(responseMessage: "No Graph Points Found"), null);
        } else {
          // Make Annotations for BuySellAnnotations
          _buySellAnnotation.forEach((dynamic d) => _annotation.add(d));

          // Update Graph Data
          final UserGraph _uG = UserGraph(
              productSpecMarket: _specMarketList, settings: GraphSettings());
//        productBloc.updateGraphData(_uG);
//     productBloc.

          _updateGraphStream(ActionState.SUCCESS, null, _uG);
        }

        // Get Called Web Socket Always => There is Graph point or Not, Not an Issue
        getGraphDataSocket();

//      _failedSubject.sink.add(null);
      }
    } catch (e) {
      //print("Error In Fetching Graph Data: ${e.toString()}");
    }
  }

  void switchTimeFrameInterval(int timeFrameId) async {
    try {
      if (timeFrameId != null) {
        int specId = productBloc.getCurrentUserProduct.productSpecId;

        final ResponseResult _result = await productBloc.getRepository
            .getTimeFrameGraphData(specId, _currentMarketIds, timeFrameId);

        if (_result.data is Failure) {
          // Failed
          final Failure error = _result.data;
          //print('Failed To Fetch Data : ${error.responseMessage}');
          return;
        }
        final List<ProductSpecMarket> _specMarketList = _result.data;

        _updateGraphStream(
            ActionState.SUCCESS,
            null,
            UserGraph(
                productSpecMarket: _specMarketList, settings: GraphSettings()));
      }
    } catch (e) {
      _updateGraphStream(
          ActionState.ERROR,
          Failure(responseMessage: "Failed to fetch data ${e.toString()}"),
          null);
    }
  }

  /// Get GraphData From Socket
  void getGraphDataSocket() {
    //print("Graph Channel Id: $_currentMarketIds");

    webSocketRepository.graphDataChannel(_currentMarketIds, onSubscribed: () {
      ////print("Subscribed To Graph Channel");
    }, onData: (LastTrade lastTrade) {
//      print("Receiving Graph Points: ${lastTrade.toJson()}---------");

      // This will Iterate, The no of ProductSpecMarkets is Selected By User To See Graph
      lastTrade.lastTradedPrices.forEach((LastTradedPrices lastTradePrice) {
        if (userGraph == null ||
            lastTradePrice == null ||
            lastTradePrice.lastTradedPrice == null) return;
        userGraph.productSpecMarket
            .forEach((ProductSpecMarket productSpecMarket) {
          /// Compare With Spec Id and LastTradePrice id
//          print(
//              "Spec Id: ${productSpecMarket.id} Last Traded:${lastTradePrice.id}");
          if (productSpecMarket.id == lastTradePrice.id) {
            productSpecMarket.graphData
                .insert(0, lastTradePrice.lastTradedPrice);
//            spec.graphData.add(lastTradePrice.lastTradedPrice);
//            print(
//                "Live Socket Graph Point Date: ${lastTradePrice.lastTradedPrice.dateTime}");
////
//            print(
//                "Live Socket Graph Point Price:  ${lastTradePrice.lastTradedPrice.price}");
          }
        });
      });

//      final ProductSpecMarket spec =
//          userGraph.productSpecMarket[userGraph.productSpecMarket.length - 1];
//      //print(
//          "Last Update Price To UserGraph: ${spec.graphData[spec.graphData.length - 1].price}");
//      //print(
//          "Last Update Date To UserGraph: ${spec.graphData[spec.graphData.length - 1].dateTime}");

      // Update Ui
      _updateGraphStream(ActionState.SUCCESS, null, userGraph);
    });
  }
}
