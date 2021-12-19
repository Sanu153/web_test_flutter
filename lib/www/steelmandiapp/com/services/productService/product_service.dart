import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/market_grouping.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_category.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_sepeartor.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';

class ProductService {
  Map<String, String> headers(token) =>
      {"Content-Type": "application/json", "Authorization": "$token"};

  Future<ResponseResult> getProductSpecMarkets(String token, int id,
      {bool isAdd}) async {
    //print("Authenticate Token: $token");
    List<ProductSpecMarket> _specMarketList;
    Failure _failure;
    List<MarketGrouping> _marketGrouping;

    ResponseResult _typedResult;
    try {
      print(
          "${Endpoint.PRODUCT_SPEC_MARKET_DETAILS_URL}/${id.toString()}/market_hierarchy_details");
      http.Response response = await http.get(
          "${Endpoint.PRODUCT_SPEC_MARKET_DETAILS_URL}/${id.toString()}/market_hierarchy_details",
          headers: headers(token));
      final Map<String, dynamic> content = json.decode(response.body);
//      //print(content);

      if (response.statusCode == 200) {
        if (content['response_status'] == 'success' &&
            content.containsKey("product_spec_markets")) {
          _specMarketList = List<ProductSpecMarket>();
          _marketGrouping = List<MarketGrouping>();
          final List collection = content['product_spec_markets'];
          final List _checker = List();

          if (collection.length != 0) {
            _specMarketList = collection
                .map((json) => ProductSpecMarket.fromJson(json))
                .toList();
            if (isAdd) {
              // Making Grouping
              _specMarketList.forEach((specMarket) {
                if (!_checker.contains(specMarket.groupingName)) {
                  _checker.add(specMarket.groupingName);
                  _marketGrouping
                      .add(HeaderPoint(groupingName: specMarket.groupingName));
                }

                _marketGrouping.add(specMarket);
              });
              _typedResult =
                  ResponseResult<Success>(data: Success(data: _marketGrouping));
            } else {
              _typedResult =
                  ResponseResult<Success>(data: Success(data: _specMarketList));
            }
          } else {
            _failure = Failure(
                responseMessage: "No markets available",
                responseStatus: ResponseStatus.FAILED_STATUS);
            _typedResult = ResponseResult<Failure>(data: _failure);
          }
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

//        //print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      //print("Errror: $e");
      _failure = Failure(
          responseMessage: "Error occured during execution",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  Future<ResponseResult> getPreferProductList(String token, bool isAdd) async {
    //print("Authenticate Token: $token");
    List<ProductCategory> _preferProductCategoryList;
    Failure _failure;
    //print("Is Add: $isAdd : ${Endpoint.GET_ALL_PRODUCT_URL}");

    ResponseResult _typedResult;
    try {
      http.Response response =
          await http.get(Endpoint.GET_ALL_PRODUCT_URL, headers: headers(token));
      final content = json.decode(response.body);
      //print("Content: ${content}");

      if (response.statusCode == 200) {
        if (content['response_status'] == 'success') {
          _preferProductCategoryList = List<ProductCategory>();
          List<ProductItem> _listSeparator = List<ProductItem>();
          final List collection = content['product_types'];
          //print(collection);
          if (collection.length != 0) {
            _preferProductCategoryList = collection
                .map((json) => ProductCategory.fromJson(json))
                .toList();
            if (isAdd) {
              _preferProductCategoryList.forEach((ProductCategory category) {
                _listSeparator.add(
                    ProType(name: category.productTypeName, id: category.id));
                category.products.forEach((Product p) {
                  _listSeparator.add(p);
                });
              });
              _typedResult =
                  ResponseResult<Success>(data: Success(data: _listSeparator));
            } else {
              _typedResult = ResponseResult<Success>(
                  data: Success(data: _preferProductCategoryList));
            }
          } else {
            _failure = Failure(
                responseMessage: "No products available",
                responseStatus: ResponseStatus.FAILED_STATUS);
            _typedResult = ResponseResult<Failure>(data: _failure);
          }
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

//        //print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      //print(e);
      _failure = Failure(
          responseMessage: "Please check your internet settings",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

// Get Default Case Products
  Future<ResponseResult> getDefaultProduct(String token) async {
    Product _product;
    List<ProductSpecMarket> _markets;
    Failure _failure;
    BuySellCount _counter;
    ResponseResult _typedResult;
    Map<String, dynamic> jsonData;
    try {
      http.Response response = await http.get(Endpoint.PRODUCT_SPEC_DEFAULT_URL,
          headers: headers(token));
//      print(Endpoint.PRODUCT_SPEC_DEFAULT_URL);
//      print(response.body);
      final Map<String, dynamic> content = json.decode(response.body);
//      print(content);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        List _dataSets = [];
        if (content.containsKey('product')) {
          /// Converting into Product Structure
          jsonData = content['product'];
          final List _specList = List();
          _specList.add(content['product_spec']);
          jsonData["product_specs"] = _specList;
          //print("JSON Data: $jsonData");
          _product = Product.fromJson(jsonData);
          _dataSets.add(_product);
          if (content.containsKey('product_spec_markets') &&
              content['product_spec_markets'] != null) {
            final List collection = content['product_spec_markets'];
            _markets =
                collection.map((v) => ProductSpecMarket.fromJson(v)).toList();
            //print("Market Length: $_markets");
            _dataSets.add(_markets);
          }
          final int totalRequestCount = content['total_requests_count'];
          final int buyRequestCount = content['buy_requests_count'];
          final int sellRequestCount = content['sell_requests_count'];
          final int productSpecId = content['product_spec']['id'];
          final int productId = _product.id;
          _counter = BuySellCount(
              productId: productId,
              productSpecId: productSpecId,
              buyRequestCount: buyRequestCount,
              sellRequestCount: sellRequestCount,
              totalRequestCount: totalRequestCount);
          _dataSets.add(_counter);
          _typedResult = ResponseResult(data: _dataSets);
        } else {
          _failure = Failure(
              responseMessage: "No products available",
              responseStatus: ResponseStatus.FAILED_STATUS);
          _typedResult = ResponseResult<Failure>(data: _failure);
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

        //print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      print("Error Caught In Default Service: ${e.toString()}");
      _failure = Failure(
        responseMessage: "Something went wrong",
      );
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  // Get MarketGraph
  Future<ResponseResult> getProductSpecMarketGraph(String token,
      {int specId, List marketsListId}) async {
    Product _product;
    List<ProductSpecMarket> _markets;
    Failure _failure;
    BuySellCount _counter;
    ResponseResult _typedResult;
    Map<String, dynamic> jsonData;
    try {
      final String _url =
          Endpoint.GET_MARKET_GRAPH_URL.replaceAll("{id}", specId.toString());

      // remove Brackets from List=[17,45,56] => 17,45,56
      final _marketList = marketsListId
          .toString()
          .substring(1, marketsListId.toString().length - 1);
      URLQueryParams queryParams = URLQueryParams();
      queryParams.append(('product_spec_markets'), _marketList);
//      queryParams.append('time_frame_id', timeFrameId);
      final String url = _url + queryParams.toString();
      print("Graph Data Url: $url");
      http.Response response = await http.get(url, headers: headers(token));
      if (response.statusCode == 500)
        return _typedResult = ResponseResult<Failure>(data: Failure());

      final Map<String, dynamic> content = json.decode(response.body);
//      //print("JSON Data: $content");

      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        final List<dynamic> _annotationList = List<dynamic>();
        List _dataSets =
            []; // Will Return List Of DataSets[Product, List<ProductSpecMarket>, BuySellCounter, List<Annotation>]
        if (content.containsKey('product')) {
          /// Converting into Product Structure => Product Takes as List Of ProductSpec
          jsonData = content['product'];
          final List _specList = List();
          _specList.add(content['product_spec']);
          jsonData["product_specs"] = _specList;
          _product = Product.fromJson(jsonData);
          // Adding Product Instance Into DataSet List
          _dataSets.add(_product);
          if (content.containsKey('product_spec_markets') &&
              content['product_spec_markets'] != null) {
            final List collection = content['product_spec_markets'];
            _markets =
                collection.map((v) => ProductSpecMarket.fromJson(v)).toList();
            //print("Market Length: $_markets");
            _dataSets.add(_markets);
          }

          final int totalRequestCount = content['total_requests_count'];
          final int buyRequestCount = content['buy_requests_count'];
          final int sellRequestCount = content['sell_requests_count'];
          final int productSpecId = content['product_spec']['id'];
          final int productId = _product.id;
          _counter = BuySellCount(
              productId: productId,
              productSpecId: productSpecId,
              buyRequestCount: buyRequestCount,
              sellRequestCount: sellRequestCount,
              totalRequestCount: totalRequestCount);
          _dataSets.add(_counter);
          if (content.containsKey('buy_requests') &&
              content.containsKey('sell_requests')) {
            final List _buyCollection = content['buy_requests'];
            final List _sellCollection = content['sell_requests'];
            final List<TradeBuySellRequest> _reL = _buyCollection
                .map((json) => TradeBuySellRequest.fromJson(json))
                .toList();
            final List<TradeBuySellRequest> _selTrade = _sellCollection
                .map((json) => TradeBuySellRequest.fromJson(json))
                .toList();

            if (_reL.length > 0) {
              _reL.forEach((TradeBuySellRequest tr) => _annotationList.add(tr));
            }
            if (_selTrade.length > 0) {
              _selTrade
                  .forEach((TradeBuySellRequest tr) => _annotationList.add(tr));
            }
            _dataSets.add(_annotationList);
          }
          _typedResult = ResponseResult(data: _dataSets);
        } else {
          _failure = Failure(
              responseMessage: "No products available",
              responseStatus: ResponseStatus.FAILED_STATUS);
          _typedResult = ResponseResult<Failure>(data: _failure);
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

        //print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      //print(e);
      _failure = Failure(
          responseMessage: "Something went wrong",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

// For Add product => Type All
//  `

// Get Graph Points on TimeFrame Changed
  Future<ResponseResult> getPointsOnTimeFrame(String token,
      {int specId, List marketsListId, int timeFrameId}) async {
    ResponseResult _result;
    Failure _failure;
    try {
      final String _url = Endpoint.TIME_INTERVAL_GRAPH_DATA
          .replaceAll("{productSpecId}", specId.toString());

      // remove Brackets from List=[17,45,56] => 17,45,56
      final _marketList = marketsListId
          .toString()
          .substring(1, marketsListId.toString().length - 1);
      URLQueryParams queryParams = URLQueryParams();
      queryParams.append(('product_spec_markets'), _marketList);
      queryParams.append('time_frame_id', timeFrameId);
      final String url = _url + queryParams.toString();
      print("TIme Interval URL: $url");
      http.Response _response = await http.get(url, headers: headers(token));

      final Map<String, dynamic> content = json.decode(_response.body);

      if (_response.statusCode == 200 &&
          content['response_status'] == 'success') {
//        print(content['product_spec_markets']);
        final List collection = content['product_spec_markets'];
        final List<ProductSpecMarket> _specMarket =
            collection.map((json) => ProductSpecMarket.fromJson(json)).toList();
        print("Spec Market Data In Service: ${_specMarket.length}");
        _result = ResponseResult<List<ProductSpecMarket>>(data: _specMarket);
      } else {
        _result = ResponseResult<Failure>(
            data: Failure(
                responseMessage: content['response_message'],
                responseStatus: content['response_status']));
      }
    } catch (e) {
      //print('Error While Fetching Data: $e');
      _result = ResponseResult<Failure>(data: Failure());
    }
    return _result;
  }
}
