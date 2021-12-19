import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';

class SupportChatService {
  Map<String, String> _headers(token) =>
      {"Content-Type": "application/json", "Authorization": "$token"};

  // Update User Image
  Future<ResponseResult> postFeedback(
      String token, Map<String, dynamic> data) async {
    ResponseResult _responseResult;
    Failure _failure;

    try {
      final body = json.encode(data);

      final http.Response response = await http.post(
          Endpoint.SUPPORT_CHART_FEEDBACK_URL,
          headers: _headers(token),
          body: body);

//      final Map<String, dynamic> content = json.decode(response.body);
      final content = json.decode(response.body);
      print(content);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        _responseResult = ResponseResult<ResponseFlags>(
            data: ResponseFlags.fromJson(content));
      } else {
        _failure = Failure(
            responseStatus: "Failed",
            responseMessage: 'Unable to post your feedback',
            statusCode: response.statusCode);

        _responseResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      print("Error In Adding Feedback: $e");
      _responseResult = ResponseResult<Failure>(
          data: Failure(
              responseStatus: 'Check your internet connectivity',
              responseMessage: e.toString()));
    }
    return _responseResult;
  }
}
//
//
//Future<ResponseResult> postFeedback(
//    String token, Map<String, dynamic> data) async {
//  ResponseResult _responseResult;
//  Failure _failure;
//
//  try {
//    final Dio dio = Dio();
//    print("Feedback Data In Service: $data");
//    FormData _fd = new FormData.fromMap({
//      "first_name": data['first_name'],
//      "last_name": data['last_name'],
//      "email": data['email'],
//      "message": data['message'],
//      "feedback_category": data['feedback_category'],
//      "file": data['file'] == null
//          ? null
//          : await MultipartFile.fromFile(data['file'].path,
//          filename: data['file'].path),
//    });
//
//    //print("User Updating Info: $_fd");
//
//    final Response response =
//    await dio.post(Endpoint.SUPPORT_CHART_FEEDBACK_URL,
//        data: _fd,
//        options: Options(
//          method: 'POST',
//          followRedirects: false,
//          headers: _headers(token),
//        ));
//
////      final Map<String, dynamic> content = json.decode(response.body);
//    if (response.statusCode == 200) {
//      final content = response.data;
//      _responseResult = ResponseResult<ResponseFlags>(
//          data: ResponseFlags(responseMessage: content['response_status']));
//    } else {
//      _failure = Failure(
//          responseStatus: "Failed",
//          responseMessage: 'Unable to post your feedback',
//          statusCode: response.statusCode);
//
//      _responseResult = ResponseResult<Failure>(data: _failure);
//    }
//  } catch (e) {
//    //print("Error In Adding User Profile Avatar: $e");
//    _responseResult = ResponseResult<Failure>(
//        data: Failure(responseStatus: 'Check your internet connectivity'));
//  }
//  return _responseResult;
//}
