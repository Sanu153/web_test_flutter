//import 'dart:convert';
//
//import 'package:http/http.dart' as http;
//import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_model.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_request.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';
//
//class GeneralService {
//  Map<String, String> headers(token) =>
//      {"Content-Type": "application/json", "Authorization": "$token"};
//
//// Add BUY/Sell Request
//  Future<ResponseResult> general(
//      String token, Map<String, dynamic> dataSet) async {
//    Failure _failure;
//    BuySellCount _counter;
//    ResponseResult _typedResult;
//    ResponseFlags _responseFlag;
//
//    final _body = json.encode(dataSet);
//    //print(_body);
//    try {
//      http.Response response = await http.post(Endpoint.GET_ANNOUNCEMENT_URL,
//          body: _body, headers: headers(token));
//      final Map<String, dynamic> content = json.decode(response.body);
//
//      if (response.statusCode == 200 &&
//          content['response_status'] == 'success') {
//        _responseFlag = ResponseFlags.fromJson(content);
//        _counter = BuySellCount(
//            totalRequestCount: content['total_requests_count'],
//            sellRequestCount: content['sell_requests_count'],
//            buyRequestCount: content['buy_requests_count']);
//        //print("Sell Count In Service: ${content['sell_requests_count']}");
//        _typedResult =
//            ResponseResult(data: Success(data: [_responseFlag, _counter]));
//      } else {
//        _failure = Failure(
//            responseMessage: content['response_message'],
//            responseStatus: content['response_status']);
//        _typedResult = ResponseResult<Failure>(data: _failure);
//
//        //print("Status Not Success: ${response.body}");
//      }
//    } catch (e) {
//      //print(e);
//      _failure = Failure(
//          responseMessage: "Please check your internet settings",
//          responseStatus: ResponseStatus.ERROR_STATUS);
//      _typedResult = ResponseResult<Failure>(data: _failure);
////      throw Exception("Some Internal Error");
//    }
//
//    return _typedResult;
//  }
//}
