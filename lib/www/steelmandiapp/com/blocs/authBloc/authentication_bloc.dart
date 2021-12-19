import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/AuthenticateState.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/authRepository/auth_repository.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/webSocketRepository/websocket_repo.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart'
    show CONFIRMATION_ERROR_STATUS;
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/notification_manager.dart';

class AuthenticationBloc {
  final DataManager dataManager;
  final authenticationRepo = AuthRepository();
  final WebSocketRepository socketRepository;
  final NotificationManager notificationManager;

  final PublishSubject<AuthenticationState> _authSubject =
      PublishSubject<AuthenticationState>();

  Observable<AuthenticationState> get authenticate$ => _authSubject.stream;

  AuthenticationBloc(
      {@required this.dataManager,
      this.socketRepository,
      this.notificationManager});

  void dispose() {
    ////print("Auth Disposer: Called******************************************");
    _authSubject.drain();
    _authSubject.close();
  }

  void reOpen() {
    if (_authSubject.isClosed) {
      ////print("AuthStream Closed");
      _authSubject.sink.add(AuthenticationState.initial());
    }
  }

  autoAuthenticate() async {
//    reOpen();
    try {
      ////print("SPLASH APP STARTED");
      _authSubject.add(AuthenticationState.initial());
      ////print("SPLASH APP INITIATED");

      await Future.delayed(Duration(seconds: 1));

      List<Map<String, dynamic>> userInfo =
          await authenticationRepo.readUserInfoFromDevice();
      final String _authToken = await authenticationRepo.getAuthToken();
//      ////print("AUth Token AUTH Bloc: $_authToken");
//    ////print("User Data From DB: $userInfo");
      if (userInfo.length > 0) {
        final Map<String, dynamic> userData = userInfo[0];
//      ////print(userData);

        dataManager.authUser = AuthUser.fromJsonSqlflite(userData);
        final AuthUser _authUser = dataManager.authUser;
        dataManager.authenticationToken = _authToken;

//        ////print("User State: STARTED");
        if (_authUser.responseStatus == CONFIRMATION_ERROR_STATUS &&
            _authToken == null) {
//          ////print("User State: NOT_APPROVED");
          _authSubject.sink.add(AuthenticationState.notApproved());
        } else if (_authToken == null &&
            _authUser.responseStatus == SUCCESS_STATUS) {
          // When A User Logged Out=> User Signinig in Successfully and So Tht The User Status is Success
//          ////print("User State: LOGGED_OUT");
          _authSubject.add(AuthenticationState.signedOut());
        } else if (_authToken != null && !await getPreferValue()) {
          // new User

//          ////print("User State: NEW");
//          ////print("Token: ${dataManager.authenticationToken}");

          _authSubject.add(AuthenticationState.newUser());
        } else {
          dataManager.authenticationToken = _authToken;
//          ////print("User State: SUCCESS || VERIFIED");
//          ////print("Token: ${dataManager.authenticationToken}");
          _authSubject.sink.add(AuthenticationState.authenticated());
        }
      } else {
//        ////print("User State: NOT_AUTHENTICATED");
        _authSubject.sink.add(AuthenticationState.failed());
      }
    } catch (e) {
//      reOpen();
      _authSubject.sink.add(AuthenticationState.failed());

      ////print("Error Occured In Authentication: ${e.toString()}");
    }
  }

  void updateAuthState(AuthenticationState state) {
    ////print("Authentication State After Login Successs: $state");

    if (state.authenticated ==
        AuthenticationState.authenticated().authenticated) {
      ////print("Authentication Updated To authenticated");
      _authSubject.sink.add(AuthenticationState.authenticated());
    }
  }

  Future<bool> logout() async {
//    ProductBloc productBloc;
    try {
      print("Logout");
      final token = dataManager.authenticationToken;
      final fcm = await notificationManager.getFcmToken();
      print(token);
      print(fcm);
      final ResponseResult _responseResult =
          await authenticationRepo.onSignOutService(token, fcm);
      if (_responseResult.data is Failure) {
        return false;
      }
      final bool result = await authenticationRepo.loggedOut();
      if (result) {
        // UnSubscribe All Socket
        socketRepository.unSubscribe();
      }
    } catch (e) {
      print("Error Caught In SignOut: $e");
      return false;
    }
    print("TTT");
    return true;
  }

  // Email Operations
  Future<bool> saveEmail({String email}) async {
    ////print(email);
    return await authenticationRepo.saveEmail(email: email);
  }

  Future<String> getEmail() async {
    return await authenticationRepo.getEmail();
  }

  Future<ResponseFlags> verifyEmail({String email}) async {
    ResponseFlags _flag = await authenticationRepo.verifyEmail(email: email);
    if (_flag != null) {
      bool result = await saveEmail(email: email);
      if (result) {
        return _flag;
      } else {
        ////print("Server Response Generated\nBut Failed to Save In Device");
        return null;
      }
    }
    return null;
  }

  Future<bool> getSkipInfo() async {
    return await authenticationRepo.getSkipInfo();
  }

  // Preference Setup
  Future<bool> savePreferValue({bool prefer, bool newUser}) async {
    bool isPrefer = await authenticationRepo.savePreferValue(prefer);
    if (isPrefer) {
      // Update New User => true to False

      dataManager.authUser.user.newUser = newUser;

      int result = await authenticationRepo.updateNewUser(
          authUser: dataManager.authUser);
      if (result == 0) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> getPreferValue() async {
    bool v = await authenticationRepo.getPreferValue();
    return v == null ? false : v;
  }

  // Get User Profile
  Future<ResponseResult> getUserProfile() async {
    ResponseResult _result = await authenticationRepo
        .getUserProfileInfo(dataManager.authenticationToken);
    if (_result.data is Success) {
      final UserModel _user = _result.data.data;

      // Update Model
      dataManager.authUser.user = _user;

      // Update Local Database
      _updateDataBaseUser(dataManager.authUser);
    }
    return _result;
  }

// Update User Password
  Future<ResponseResult> updateUserPassword(Map<String, dynamic> passwordSet) =>
      authenticationRepo.updateUserPassword(dataManager.authenticationToken,
          newPass: passwordSet['new_password'],
          oldPass: passwordSet['old_password']);

// Update User Profile
  Future<ResponseResult> updateUserProfile(Map<String, dynamic> data) async {
    ResponseResult _result = await authenticationRepo.updateUserProfile(
        dataManager.authenticationToken, data);
    if (_result.data is UserModel) {
      final UserModel _user = _result.data;
      // Update Model
      dataManager.authUser.user = _user;

      // Update Local Database
      _updateDataBaseUser(dataManager.authUser);
    }
    return _result;
  }

  void _updateDataBaseUser(AuthUser authUser) async {
    final int result =
        await authenticationRepo.updateDBUser(authUser.toJsonSqlFlite());
    if (result <= 0) {
      //print("Updating User Into Database: Failed: $result");
    } else {
      //print("Updating User Into Database: Success: $result");
    }
  }

// Update User Profile Avatar
  Future<ResponseResult> updateUserProfileAvatar(File file) =>
      authenticationRepo.updateUserProfileAvatar(
          dataManager.authenticationToken, file);
}
