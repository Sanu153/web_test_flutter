import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/adherence.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/contract.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/tradebook_schedule.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/request_responder.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';

class TradeService {
  Map<String, String> headers(token) =>
      {"Content-Type": "application/json", "Authorization": "$token"};

  // Set Alert
  Future<ResponseResult> setAlert(String token,
      {int marketId, String validity, double price, int productSpecId}) async {
    Failure _failure;
    ResponseResult _typedResult;
    ResponseFlags _responseFlag;

    final _body = json.encode({
      "product_spec_id": productSpecId,
      "market_hierarchy_id": marketId,
      "price_per_unit": price,
      "occurrence": validity
    });
    //print(_body);
    try {
      http.Response response = await http.post(Endpoint.USER_ALERT,
          body: _body, headers: headers(token));
      final Map<String, dynamic> content = json.decode(response.body);

      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        _responseFlag = ResponseFlags.fromJson(content);

        _typedResult = ResponseResult(data: _responseFlag);
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
          responseMessage: "Please check your internet settings",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

// Add BUY/Sell Request
  Future<ResponseResult> onBuySellRequestSubmit(
      String token, Map<String, dynamic> dataSet) async {
    Failure _failure;
    BuySellCount _counter;
    ResponseResult _typedResult;
    ResponseFlags _responseFlag;

    final _body = json.encode(dataSet);
    print(_body);
    try {
      http.Response response = await http.post(Endpoint.ADD_BUYSELL_REQUEST_URL,
          body: _body, headers: headers(token));
      final Map<String, dynamic> content = json.decode(response.body);

      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        _responseFlag = ResponseFlags.fromJson(content);
        _counter = BuySellCount(
            totalRequestCount: content['total_requests_count'],
            sellRequestCount: content['sell_requests_count'],
            buyRequestCount: content['buy_requests_count']);
        _typedResult =
            ResponseResult(data: Success(data: [_responseFlag, _counter]));
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
          responseMessage: "Please check your internet settings",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  // Get All Buy/Sell Request
  Future<ResponseResult> getTradeBuySellRequest(
      String token, int productSpecId, List<int> marketId,
      {bool isBuy = true}) async {
    //print("Authenticate Token: $token");
    TradeRequest _tradeRequest;
    Failure _failure;

    ResponseResult _typedResult;
    String tradeType = isBuy ? 'buy' : 'sell';
    final String marktList =
        marketId.toString().substring(1, marketId.toString().length - 1);
    try {
      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("request_type", tradeType);
      queryParams.append("product_spec_markets", marktList);
      print(
          "BuySell URL: ${"${Endpoint.GET_BUY_SELL_REQUEST_URL}/$productSpecId?$queryParams"}");
      http.Response response = await http.get(
          "${Endpoint.GET_BUY_SELL_REQUEST_URL}/$productSpecId?$queryParams",
          headers: headers(token));
      final content = json.decode(response.body);

      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
          _tradeRequest = TradeRequest.fromJson(content);

          // Do Filter
          final List<ListItem> _filteredList = List<ListItem>();
          final List<TradeBuySellRequest> _tradeBuySellList =
              _tradeRequest.tradeBuySellRequest;
          final String _today = DateTime.now().toString().split(' ')[0];
          final List _checker = List();

          _tradeBuySellList.forEach((item) {
            final String _createdDate = item.createdAt.toString().split(' ')[0];
//            //print("Created: $_createdDate");

            if (!_checker.contains(_createdDate)) {
              if (_today == _createdDate) {
                _checker.add(_createdDate);
                _filteredList.add(HeadingItem("Today"));
              } else {
                _checker.add(_createdDate);
                _filteredList.add(HeadingItem("$_createdDate"));
              }
              _filteredList.add(item);
            } else {
              _filteredList.add(item);
            }
          });
          _typedResult = ResponseResult<Success>(
              data: Success(data: [_tradeRequest, _filteredList]));
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

  // Respond A Request
  Future<ResponseResult> buySellTradeRespond(
      String token, RespondNegotiation data) async {
    //print("Authenticate Token: $token");
    ResponseFlags _flags;

    Failure _failure;

    ResponseResult _typedResult;
    TradeBuySellRequest tradeBuySellRequest;

    try {
      final body = json.encode(data.toJson());
      //print(Endpoint.GET_BUY_SELL_RESPOND_URL);
      //print(body);
      http.Response response = await http.post(
          "${Endpoint.GET_BUY_SELL_RESPOND_URL}",
          body: body,
          headers: headers(token));
      //print((response.statusCode));
      final content = json.decode(response.body);
      //print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
          _flags = ResponseFlags.fromJson(content);
          tradeBuySellRequest =
              TradeBuySellRequest.fromJson(content['request']);
          final List<dynamic> _list = List<dynamic>();
          _list.add(_flags);
          _list.add(tradeBuySellRequest);
          _typedResult = ResponseResult<Success>(data: Success(data: _list));
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

  // Get Product and Market Info
  Future<ResponseResult> getProductAndMarketInfo(String token,
      {int specId, List<int> marketIds}) async {
    //print("Authenticate Token: $token");
    Failure _failure;

    ResponseResult _typedResult;
    ProductSpec productSpec;
    List<ProductSpecMarket> specMarketL;

    try {
      final String url = Endpoint.GET_PRODUCT_MARKET_INFO_URL
              .replaceAll("{id}", specId.toString()) +
          marketIds.toString();
      print(url);
      http.Response response = await http.get(url, headers: headers(token));
      final content = json.decode(response.body);
      //print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
          productSpec = ProductSpec.fromJson(content['product_spec']);
          final List collection = content['markets'];
          if (!collection.contains(null)) {
            specMarketL = List<ProductSpecMarket>();
            specMarketL = collection
                .map((json) => ProductSpecMarket.fromJson(json))
                .toList();
          }

          _typedResult = ResponseResult<Success>(
              data: Success(data: [productSpec, specMarketL]));
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

  // Get Product and Market Info
  Future<ResponseResult> marketSubscription(String token,
      {int specId, bool subscribed}) async {
    //print("Authenticate Token: $token");
    Failure _failure;

    ResponseResult _typedResult;
    try {
      final String url = subscribed
          ? Endpoint.GET_MARKET_SUBSCRIPTION
              .replaceAll("{id}", specId.toString())
          : Endpoint.GET_MARKET_UNSUBSCRIPTION
              .replaceAll("{id}", specId.toString());
      print(url);
      http.Response response = await http.get(url, headers: headers(token));
      final content = json.decode(response.body);
      //print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
          _typedResult = ResponseResult<ResponseFlags>(
              data: ResponseFlags(
                  responseStatus: content['response_status'],
                  responseMessage: content['message']));
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
//  `

// Get Trade Book Contract
  Future<ResponseResult> getTradeContract(String token) async {
    //print("Authenticate Token: $token");
    Failure _failure;

    ResponseResult _typedResult;

    try {
      final String url = Endpoint.GET_TRADE_CONTRACT;
      //print(url);
      http.Response response = await http.get(url, headers: headers(token));
      final content = json.decode(response.body);
      //print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
          List<Contract> _contracts = List<Contract>();
          final List collection = content['get_orders'];
          _contracts =
              collection.map((json) => Contract.fromJson(json)).toList();

          _typedResult =
              ResponseResult<Success>(data: Success(data: _contracts));
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

// Get Current/Active Schedule
  Future<ResponseResult> getTradeBookSchedule(String token) async {
    Failure _failure;
    ResponseResult _typedResult;
    try {
      final String url = Endpoint.GET_TRADE_SCHEDULE;
      print("GET_TRADE_SCHEDULE: $url");
      http.Response response = await http.get(url, headers: headers(token));
      final content = json.decode(response.body);
      print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
          final TradeBookSchedule schedule =
              TradeBookSchedule.fromJson(content);

          _typedResult = ResponseResult<Success>(data: Success(data: schedule));
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

//        //print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      print("Error in Fetching Schedules: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Please check your internet settings",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

// Get Trade Responders History
  Future<ResponseResult> getTradeRequestResponders(String token) async {
    Failure _failure;
    ResponseResult _typedResult;
    try {
      final String url = Endpoint.GET_TRADE_REQUEST_RESPONDERS;
      //print(url);
      http.Response response = await http.get(url, headers: headers(token));
      final content = json.decode(response.body);
      //print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
          List<RequestResponder> _responders = List<RequestResponder>();
          final List collection = content['responders'];
          _responders = collection
              .map((json) => RequestResponder.fromJson(json))
              .toList();

          _typedResult =
              ResponseResult<Success>(data: Success(data: _responders));
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      print("Error Caught In Fetching Responders: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Please check your internet settings",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  // POST Adherence
  Future<ResponseResult> postAdherence(String token,
      {Map<String, dynamic> data}) async {
    Failure _failure;
    ResponseResult _typedResult;
    try {
      final body = json.encode(data);
      print(body);
      http.Response response = await http.post(Endpoint.POST_ADHERENCE,
          headers: headers(token), body: body);
      final content = json.decode(response.body);
      print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
//
          _typedResult = ResponseResult<ResponseFlags>(
              data: ResponseFlags(responseMessage: "Successfully submitted"));
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      print("Error Caught In Posting Adherence: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Please check your internet settings",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  // Get Adherence
  Future<ResponseResult> getAdherence(String token, {int orderId}) async {
    Failure _failure;
    ResponseResult _typedResult;
    try {
      final String _url =
          Endpoint.GET_ADHERENCE.replaceAll("{orderId}", orderId.toString());
//      print("Get Adherence URL: $_url");
      http.Response response = await http.get(_url, headers: headers(token));
      final content = json.decode(response.body);
//      print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
          final List _collection = content['contract_adherence'];
          final List<Adherence> _ads =
              _collection.map((json) => Adherence.fromJson(json)).toList();
          _typedResult = ResponseResult<Success>(data: Success(data: _ads));
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      print("Error Caught In Fetching Adherence: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Please check your internet settings",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  // PUT Update Schedule
  Future<ResponseResult> updateSchedule(String token,
      {Map<String, dynamic> data}) async {
    Failure _failure;
    ResponseResult _typedResult;
    try {
      final body = json.encode(data);
      http.Response response = await http.put(Endpoint.UPADTE_SCHEDULE,
          headers: headers(token), body: body);

      final content = json.decode(response.body);
      if (response.statusCode == 200) {
        if (content['response_status'] == ResponseStatus.SUCCESS_STATUS) {
//
          _typedResult = ResponseResult<ResponseFlags>(
              data: ResponseFlags.fromJson(content));
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      print("Error Caught In Updating Schedule: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Please check your internet settings",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }
}
