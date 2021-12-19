import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/portfolio_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/order.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';

class PortfolioService {
  static Map<String, String> headers(token) =>
      {"Content-Type": "application/json", "Authorization": "$token"};

  static Future<ResponseResult> getProductSpecMarkets(String token,
      {String type}) async {
    //print("Authenticate Token IN Portfolio: $token");
    Portfolio portfolio;
    Failure _failure;

    ResponseResult _typedResult;
    try {
      final url = type == null || type == "OPENED"
          ? Endpoint.GET_OPENED_PORTFOLIO
          : Endpoint.GET_PORTFOLIO_GET_ORDER;
      //print(url);
      http.Response response = await http.get("$url", headers: headers(token));
      final Map<String, dynamic> content = json.decode(response.body);
//      print(content);

      if (response.statusCode == 200) {
        if (content['response_status'] == 'success') {
          if (content.containsKey("user_portfolio")) {
            portfolio = Portfolio.fromJson(content['user_portfolio']);
            _typedResult = ResponseResult<Portfolio>(data: portfolio);
          } else if (content.containsKey("get_orders")) {
            portfolio = Portfolio.fromJson(content['get_orders']);
            _typedResult = ResponseResult<Portfolio>(data: portfolio);
          }
        } else {
          _failure = Failure(
              responseMessage: content['response_message'],
              responseStatus: ResponseStatus.FAILED_STATUS);
          _typedResult = ResponseResult<Failure>(data: _failure);
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

//        //print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      print("Error In Portfolio Service: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Something went wrong",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  static Future<ResponseResult> postNegotiationChat(String token,
      Negotiation negotiation, String message, int responderId) async {
    Failure _failure;
    double quantityRemaining;

    ResponseResult _typedResult;
    try {
      final messageNegotiation = {
        "request_responder_id": responderId,
        "negotiation": negotiation == null ? null : negotiation.toJson(),
        "negotiation_chat_message":
            message == null ? null : {"text_message": message}
      };
      final body = json.encode(messageNegotiation);
      http.Response response = await http.post(
          "${Endpoint.PORTFOLIO_NEGOTIATION}",
          headers: headers(token),
          body: body);
      final Map<String, dynamic> content = json.decode(response.body);
//      print(content);

      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        _typedResult =
            ResponseResult<double>(data: content['quantity_available']);
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

        print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      print("Error in posting Negotiation: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Something went wrong",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  static Future<ResponseResult> getNegotiationList(
      String token, int requestResponderId) async {
    //print("Authenticate Token IN Portfolio: $token");
    Failure _failure;
    List<NegotiationListItem> _negoList;
    ResponseResult _typedResult;
    print("Chat URL: ${Endpoint.GET_PORTFOLIO_NEGOTIATION}$requestResponderId");
    try {
      http.Response response = await http.get(
          "${Endpoint.GET_PORTFOLIO_NEGOTIATION}$requestResponderId",
          headers: headers(token));
      //print("Response: ${response.body}, Status Code: ${response.statusCode}");
      final Map<String, dynamic> content = json.decode(response.body);
      //print(content);
      if (response.statusCode == 200) {
        if (content['response_status'] == 'success' &&
            content.containsKey("negotiation_list")) {
          _negoList = List<NegotiationListItem>();
          //print("Type : ${_negoList.runtimeType}");
          final List collection = content['negotiation_list']['negotiations'];
          //print(collection);

          collection.forEach((json) {
            _negoList.add(Negotiation.fromJson(json));
          });
//          _negoList =
//              collection.map((json) => Negotiation.fromJson(json)).toList();
          _typedResult =
              ResponseResult<Success>(data: Success(data: _negoList));
          //print("Length Of Negotiation: ${_negoList.length} ${_negoList.runtimeType}");
        } else {
          _failure = Failure(
              responseMessage: content['response_message'],
              responseStatus: ResponseStatus.FAILED_STATUS);
          _typedResult = ResponseResult<Failure>(data: _failure);
        }
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

//        //print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      print("Error in Retrieving Negotiation List: $e");
      _failure = Failure(
          responseMessage: "Something went wrong",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  static Future<ResponseResult> getNegotiateApproveReject(String token,
      {String type, int negotiationId}) async {
    //print("Authenticate Token IN Portfolio: $token");
    Failure _failure;
    ResponseResult _typedResult;

    final body = json
        .encode({"negotiation_id": negotiationId, "negotiation_status": type});

//    print(
//        "Approve URL: ${Endpoint.GET_PORTFOLIO_NEGOTIATION_APPROVE_REJECT}\n Body: $body");
    try {
      http.Response response = await http.post(
          "${Endpoint.GET_PORTFOLIO_NEGOTIATION_APPROVE_REJECT}",
          headers: headers(token),
          body: body);

      final Map<String, dynamic> content = json.decode(response.body);
      print(content);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        _typedResult = ResponseResult<ResponseFlags>(
            data: ResponseFlags.fromJson(content));
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
          responseMessage: "Something went wrong",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }

  // Get Schedule
  static Future<ResponseResult> getSchedule(String token, int orderId) async {
    //print("Authenticate Token IN Portfolio: $token");
    Failure _failure;
    ResponseResult _typedResult;

    print("Schedule URL: ${Endpoint.GET_SCHEDULE_URL}order_id=$orderId");
    try {
      http.Response response = await http.get(
        "${Endpoint.GET_SCHEDULE_URL}order_id=$orderId",
        headers: headers(token),
      );

      final Map<String, dynamic> content = json.decode(response.body);
//      print(content);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        final Order order = Order.fromJson(content['get_order']);
//        print(order.contract.length);
        _typedResult = ResponseResult<Success>(data: Success(data: order));
      } else {
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);

//        //print("Status Not Success: ${response.body}");
      }
    } catch (e) {
      print("Errror In Schedule Service: ${e.toString()}");
      _failure = Failure(
          responseMessage: "${e.toString()}",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
//      throw Exception("Some Internal Error");
    }

    return _typedResult;
  }
}
