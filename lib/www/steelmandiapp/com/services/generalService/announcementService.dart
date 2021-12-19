import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:steelmandi_app/www/steelmandiapp/com/models/generalModel/announce/events.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/generalModel/announce/news.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/generalModel/announce/tenders.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';

class AnnouncementService {
  Map<String, String> headers(token) =>
      {"Content-Type": "application/json", "Authorization": "$token"};

  //Service call for news api

  Future<ResponseResult> getAnnouncementNewsList(String token) async {
    Failure _failure;
    ResponseResult _typedResult;
    List<News> _newsList; //creating reference

    try {
      http.Response response = await http
          .get(Endpoint.GET_ANNOUNCEMENT_NEWS_URL, headers: headers(token));

      final Map<String, dynamic> content = json.decode(response.body);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        _newsList =
            List<News>(); //instantiate the whole list of news,initially null

        final List collection = content[
            'news']; //"news":[{},{},{}]; from response the whole list that contains the json object for news is instantiated
        //but we need to iterate through each  json object of the list and add it to the _newsList
        //print(collection);
        if (collection.length != 0) {
          _newsList =
              collection //converting each json oblect into news model type
                  .map((json) => News.fromJson(json))
                  .toList();

          _typedResult =
              ResponseResult<Success>(data: Success(data: _newsList));
          //print("Tyoed Result:$_typedResult");
        } else {
          // when no json object for news is available,"news": , is empty
          _failure = Failure(
              responseMessage: "No News available",
              responseStatus: ResponseStatus.FAILED_STATUS);
          _typedResult = ResponseResult<Failure>(data: _failure);
        }

        //data can be anytype like may be success or failure type as data :Failure() will show no error
        //  _typedResult=ResponseResult<Success>(data:Success(data: _newsList) );//data has to be success type only as <Success> is mentioned, data :Failure() will show  error
        //_newsist is //printed on UI
      } else {
        //when statuscode==200
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      //print("Errror: $e");
      _failure = Failure(
          responseMessage: "Error occured during execution.",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
    }
    return _typedResult;
  }

  //Service call for tenders api
  Future<ResponseResult> getAnnouncementTenderList(String token) async {
    Failure _failure;
    ResponseResult _typedResult;
    List<Tenders> _tendersList;

    try {
      http.Response response = await http
          .get(Endpoint.GET_ANNOUNCEMENT_TENDERS_URL, headers: headers(token));

      final Map<String, dynamic> content = json.decode(response.body);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        _tendersList =
            List<Tenders>(); //instantiate the whole list of news,initially null

        final List collection = content[
            'tenders']; //"news":[{},{},{}]; from response the whole list that contains the json object for news is instantiated
        //but we need to iterate through each  json object of the list and add it to the _newsList
        //print(collection);
        if (collection.length != 0) {
          _tendersList = collection
              .map((json) => Tenders.fromJson(json))
              .toList(); ////converting each json oblect into news model type
        } else {
          // when no json object for news is available,"news": , is empty
          _failure = Failure(
              responseMessage: "No Tenders available",
              responseStatus: ResponseStatus.FAILED_STATUS);
          _typedResult = ResponseResult<Failure>(data: _failure);
        }

        _typedResult = ResponseResult(
            data: Success(
                data:
                    _tendersList)); //data can be anytype like may be success or failure type as data :Failure() will show no error
        //  _typedResult=ResponseResult<Success>(data:Success(data: _newsList) );//data has to be success type only as <Success> is mentioned, data :Failure() will show  error
        //_newsist is //printed on UI
      } else {
        //when statuscode!==200
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      //print("Errror: $e");
      _failure = Failure(
          responseMessage: "Error occured during execution.",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
    }
    return _typedResult;
  }

  //Service call for events api
  Future<ResponseResult> getAnnouncementEventList(String token) async {
    Failure _failure;
    ResponseResult _typedResult;
    //creating reference
    List<Events> _eventsList;

    try {
      http.Response response = await http
          .get(Endpoint.GET_ANNOUNCEMENT_EVENTS_URL, headers: headers(token));

      final Map<String, dynamic> content = json.decode(response.body);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        _eventsList =
            List<Events>(); //instantiate the whole list of news,initially null

        final List collection = content[
            'events']; //"news":[{},{},{}]; from response the whole list that contains the json object for news is instantiated
        //but we need to iterate through each  json object of the list and add it to the _newsList
        //print(collection);
        if (collection.length != 0) {
          _eventsList = collection
              .map((json) => Events.fromJson(json))
              .toList(); ////converting each json oblect into news model type
        } else {
          // when no json object for news is available,"news": , is empty
          _failure = Failure(
              responseMessage: "No Events available",
              responseStatus: ResponseStatus.FAILED_STATUS);
          _typedResult = ResponseResult<Failure>(data: _failure);
        }

        _typedResult = ResponseResult(
            data: Success(
                data:
                    _eventsList)); //data can be anytype like may be success or failure type as data :Failure() will show no error
        //  _typedResult=ResponseResult<Success>(data:Success(data: _newsList) );//data has to be success type only as <Success> is mentioned, data :Failure() will show  error
        //_newsist is //printed on UI
      } else {
        //when statuscode==200
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      //print("Errror: $e");
      _failure = Failure(
          responseMessage: "Error occured during execution.",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
    }
    return _typedResult;
  }

  //Post a like
  Future<ResponseResult> postLike(String token, {int id}) async {
    Failure _failure;
    ResponseResult _typedResult;

    final body = json.encode({"id": id});

    try {
      http.Response response = await http.post(Endpoint.POST_NEWS_LIKE_URL,
          headers: headers(token), body: body);

      final Map<String, dynamic> content = json.decode(response.body);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        final responseResult = ResponseFlags.fromJson(content);

        _typedResult = ResponseResult<ResponseFlags>(data: responseResult);
      } else {
        //when statuscode==200
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      print("Error Caught in Posting Like Service: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Unable to post.",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
    }
    return _typedResult;
  }

  //Increment View
  Future<ResponseResult> postView(String token, {int id, String type}) async {
    Failure _failure;
    ResponseResult _typedResult;

    final body = json.encode({
      "id": id,
      "announcement_type": type,
    });

    try {
      http.Response response = await http.post(Endpoint.VIEW_ANNOUNCEMENT_URL,
          headers: headers(token), body: body);

      final Map<String, dynamic> content = json.decode(response.body);
      if (response.statusCode == 200 &&
          content['response_status'] == 'success') {
        final responseResult = ResponseFlags.fromJson(content);

        _typedResult = ResponseResult<ResponseFlags>(data: responseResult);
      } else {
        //when statuscode==200
        _failure = Failure(
            responseMessage: content['response_message'],
            responseStatus: content['response_status']);
        _typedResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      print("Error Caught in Posting View Service: ${e.toString()}");
      _failure = Failure(
          responseMessage: "Unable to post.",
          responseStatus: ResponseStatus.ERROR_STATUS);
      _typedResult = ResponseResult<Failure>(data: _failure);
    }
    return _typedResult;
  }
}
