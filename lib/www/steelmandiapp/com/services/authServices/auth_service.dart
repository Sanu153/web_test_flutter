import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart';

class AuthService {
  Future<ResponseResult> onLogin(
      {@required String userEmail,
      @required String userPassword,
      String fcmToken}) async {
    //print("UserEmail: $userEmail \n UserPassword: $userPassword");

    AuthUser _authUser;
    String authToken = '';

    ResponseResult responseResult;

    try {
      //print("Coming");
      final Map<String, dynamic> formBody = {
        "user": {"email": userEmail, "password": userPassword},
        "fcm_token": fcmToken
      };
      final body = json.encode(formBody);
//      //print("Login Url: ${Endpoint.LOGIN_URL}");
//      //print("Auth Data: $body");
      http.Response response =
          await http.post(Endpoint.LOGIN_URL, body: body, headers: getHeader);
//      //print("Login data: ${response.body}");
      final content = json.decode(response.body);
      print("JSON Decode Content: $content");
      final String responseStatus = content['response_status'];
      if (response.statusCode == 200 &&
          content['response_status'] == SUCCESS_STATUS) {
        // User Login Successfuly
        _authUser = AuthUser.fromJson(content);
        authToken = response.headers['authorization'];
        responseResult = ResponseResult<List>(data: [_authUser, authToken]);
      } else if (response.statusCode == 400 &&
          content['response_status'] == CONFIRMATION_ERROR_STATUS) {
        _authUser = AuthUser.fromJson(content);
        authToken = "";
        responseResult = ResponseResult<List>(data: [_authUser, authToken]);
      } else {
        responseResult =
            ResponseResult<Failure>(data: Failure.fromJson(content));
      }
    } catch (e) {
      print("Error In Login Service: ${e.toString()}");
      responseResult =
          ResponseResult<Failure>(data: Failure(responseMessage: e.toString()));
    }

    return responseResult;
  }

  Future<AuthUser> onRegister({@required Map<String, dynamic> userMap}) async {
    AuthUser _authUser;
    try {
      //print("Coming");
      final body = json.encode(userMap);
      http.Response response = await http.post(Endpoint.REGISTER_URL,
          body: body, headers: getHeader);
      //print(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        final content = json.decode(response.body);
        print(content);
        _authUser = AuthUser.fromJson(content);
      } else {
        _authUser = null;
      }
    } catch (e) {
      //print(e);
      _authUser = null;
    }

    return _authUser;
  }

  /// Sign Out
  Future<ResponseResult> onSignOut(String token, String fcm) async {
    ResponseResult _responseResult;
    Failure _failure;

    try {
      final url = Endpoint.SIGNOUT_URL + "?fcm_token=" + fcm;
      print("URL: $url");
      final http.Response response =
          await http.delete(url, headers: getAuthenticateHeader(token));

      final Map<String, dynamic> content = json.decode(response.body);
      print("Content: $content");
      if (response.statusCode == 200 &&
          content.containsKey('response_status') &&
          content['response_status'] == 'success') {
        final ResponseFlags _flags = ResponseFlags.fromJson(content);

        _responseResult = ResponseResult<ResponseFlags>(data: _flags);
      } else {
        _failure = Failure(
            responseStatus: content['response_status'],
            responseMessage: 'Unable to sign out',
            statusCode: response.statusCode);

        _responseResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      //print("Error In Fetching User Profile: $e");
      _responseResult = ResponseResult<Failure>(
          data: Failure(responseStatus: 'Check your internet connectivity'));
    }
    return _responseResult;
  }

  Future<List<dynamic>> onOtpVerify(
      {@required String email, @required String otpCode}) async {
    AuthUser _authUser;
    String authToken = "";
    try {
      String otpUrl =
          "${Endpoint.OTP_VERIFY_URL}?confirmation_token=$otpCode&email=$email";
      //print("OTP URL: $otpUrl");
      http.Response response = await http.get(otpUrl, headers: getHeader);
      if (response.statusCode == 200 || response.statusCode == 400) {
        final content = json.decode(response.body);
        //print(content);
//        //print("RESPONSE HEADER: ${response.headers}");
        authToken = response.headers['authorization'];
        //print("Authentication Token: $authToken");
        _authUser = AuthUser.fromJson(content);
      } else {
        _authUser = null;
      }
    } catch (e) {
      //print(e);
      _authUser = null;
    }

    return [_authUser, authToken];
  }

  Future<ResponseFlags> onResendOTP({@required String email}) async {
    ResponseFlags _responseFlag;
    try {
      final formData = {
        "user": {"email": email}
      };
      final body = json.encode(formData);
      http.Response response = await http.post(Endpoint.OTP_VERIFY_URL,
          body: body, headers: getHeader);
      if (response.statusCode == 200 || response.statusCode == 400) {
        final content = json.decode(response.body);
        //print(content);
        _responseFlag = ResponseFlags.fromJson(content);
      } else {
        _responseFlag = null;
      }
    } catch (e) {
      //print(e);
      _responseFlag = null;
    }

    return _responseFlag;
  }

  Future<ResponseFlags> onForgotPassword({@required String email}) async {
    ResponseFlags responseFlags;

    try {
      final formData = {
        "user": {"email": email}
      };
      final body = json.encode(formData);
      http.Response response = await http.post(
          Endpoint.FORGOT_PASSWORD_VERIFY_URL,
          body: body,
          headers: getHeader);
      if (response.statusCode == 200 || response.statusCode == 400) {
        final content = json.decode(response.body);
        //print(content);
        responseFlags = ResponseFlags.fromJson(content);
      } else {
        responseFlags = null;
//        throw Exception("Internal Error Occured While Verifying Email");
      }
    } catch (e) {
      //print(e);
      responseFlags = null;
    }
    return responseFlags;
  }

  Future<ResponseFlags> onResetPassword(
      {@required String password, @required String otpCode}) async {
    ResponseFlags responseFlags;

    try {
      final formData = {
        "user": {"reset_password_token": otpCode, "password": password}
      };
      final body = json.encode(formData);
      http.Response response = await http.put(
          Endpoint.FORGOT_PASSWORD_VERIFY_URL,
          body: body,
          headers: getHeader);
      if (response.statusCode == 200 || response.statusCode == 400) {
        final content = json.decode(response.body);
        //print(content);
        responseFlags = ResponseFlags.fromJson(content);
      } else {
        responseFlags = null;
//        throw Exception("Internal Error Occured While Verifying Email");
      }
    } catch (e) {
      //print(e);
      responseFlags = null;
    }
    return responseFlags;
  }

  Future<ResponseResult> getUserProfileInfo(String token) async {
    ResponseResult _responseResult;
    Failure _failure;

    try {
      final http.Response response = await http.get(
          Endpoint.USER_PROFILE_INFO_URL,
          headers: getAuthenticateHeader(token));

      final Map<String, dynamic> content = json.decode(response.body);

      if (response.statusCode == 200 &&
          content.containsKey('response_status') &&
          content['response_status'] == 'success') {
        final UserModel _user = UserModel.fromJson(content['user']);

        _responseResult = ResponseResult<Success>(data: Success(data: _user));
      } else {
        _failure = Failure(
            responseStatus: content['response_status'],
            responseMessage: 'Unable to fetch user profile',
            statusCode: response.statusCode);

        _responseResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      //print("Error In Fetching User Profile: $e");
      _responseResult = ResponseResult<Failure>(
          data: Failure(responseStatus: 'Check your internet connectivity'));
    }
    return _responseResult;
  }

  // Update User Password
  Future<ResponseResult> updateUserPassword(String token,
      {String oldPassword, String newPassword}) async {
    ResponseResult _responseResult;
    Failure _failure;

    try {
      final body = json
          .encode({"old_password": oldPassword, "new_password": newPassword});

      final http.Response response = await http.put(
          Endpoint.USER_UPDATE_PASSWORD_URL,
          body: body,
          headers: getAuthenticateHeader(token));

      final Map<String, dynamic> content = json.decode(response.body);

      if (response.statusCode == 200 &&
          content.containsKey('response_status') &&
          content['response_status'] == 'success') {
        _responseResult = ResponseResult<ResponseFlags>(
            data: ResponseFlags.fromJson(content));
      } else {
        _failure = Failure(
            responseStatus: content['response_status'],
            responseMessage: 'Unable to update user password',
            statusCode: response.statusCode);

        _responseResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      //print("Error In Updating User Password: $e");
      _responseResult = ResponseResult<Failure>(
          data: Failure(responseStatus: 'Check your internet connectivity'));
    }
    return _responseResult;
  }

  // Update User Profile
  Future<ResponseResult> updateUserProfile(String token,
      {Map<String, dynamic> data}) async {
    ResponseResult _responseResult;
    Failure _failure;

    try {
      final body = json.encode(data);

      //print("User Updating Info: $body");

      final http.Response response = await http.put(
          Endpoint.USER_UPDATE_PROFILE_URL,
          body: body,
          headers: getAuthenticateHeader(token));

      final Map<String, dynamic> content = json.decode(response.body);

      if (response.statusCode == 200 &&
          content.containsKey('response_status') &&
          content['response_status'] == 'success') {
        final UserModel _user = UserModel.fromJson(content['user']);

        _responseResult = ResponseResult<UserModel>(data: _user);
      } else {
        _failure = Failure(
            responseStatus: content['response_status'],
            responseMessage: 'Unable to update user profile',
            statusCode: response.statusCode);

        _responseResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      //print("Error In Updating User Profile: $e");
      _responseResult = ResponseResult<Failure>(
          data: Failure(responseStatus: 'Check your internet connectivity'));
    }
    return _responseResult;
  }

  // Update User Image
  Future<ResponseResult> updateUserProfileAvatar(
      String token, File file) async {
    ResponseResult _responseResult;
    Failure _failure;
    try {
      final Dio dio = Dio();
      FormData _fd = new FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: file.path),
      });

      //print("User Updating Info: $_fd");

      final Response response =
          await dio.post(Endpoint.USER_UPDATE_PROFILE_IMAGE_URL,
              data: _fd,
              options: Options(
                method: 'POST',
                followRedirects: false,
                headers: getAuthenticateHeader(token),
              ));

//      final Map<String, dynamic> content = json.decode(response.body);
      if (response.statusCode == 200) {
        final content = response.data;
        _responseResult = ResponseResult<ResponseFlags>(
            data: ResponseFlags(responseMessage: content['response_status']));
      } else {
        _failure = Failure(
            responseStatus: "Failed",
            responseMessage: 'Unable to update user profile',
            statusCode: response.statusCode);

        _responseResult = ResponseResult<Failure>(data: _failure);
      }
    } catch (e) {
      //print("Error In Adding User Profile Avatar: $e");
      _responseResult = ResponseResult<Failure>(
          data: Failure(responseStatus: 'Check your internet connectivity'));
    }
    return _responseResult;
  }

  Map<String, String> get getHeader =>
      {"Content-Type": "application/json", "Accept": "application/json"};

  Map<String, String> getAuthenticateHeader(String token) => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": token
      };
}
