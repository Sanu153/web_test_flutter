import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/authRepository/auth_repository.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/validation/auth_validation.dart';

class SIgnInBloc with AuthValidation {
  final DataManager dataManager;
  AuthRepository authRepo;

//  final WebSocket webSocket;

  // Defining Subjects or Like To Be StreamController with Advance Features

  //STATE  AND FAILED SUBJECT
  BehaviorSubject<ActionState> _actionStateSubject =
      BehaviorSubject<ActionState>.seeded(ActionState.INITIAL);
  BehaviorSubject<Failure> _failedSubject =
      BehaviorSubject<Failure>.seeded(null);
  BehaviorSubject<AuthUser> _authUserSubject =
      BehaviorSubject<AuthUser>.seeded(null);

  // EMAIL AND PASSWORD SUBJECT
  final BehaviorSubject<String> _emailSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordSubject = BehaviorSubject<String>();

//  final BehaviorSubject<SigninState> _signinSubject =
//      BehaviorSubject<SigninState>.seeded(SigninState.initial());

  // Observables or STream
  Observable<ActionState> get _actionState$ => _actionStateSubject.stream;

  Observable<Failure> get _onFailure$ => _failedSubject.stream;

  Observable<AuthUser> get _authUser$ => _authUserSubject.stream;

//  Observable<SigninState> get signInState$ => _signinSubject.stream;

  Stream<String> get email$ => _emailSubject.stream.transform(emailValidator);

  Stream<String> get password$ =>
      _passwordSubject.stream.transform(passwordValidator);

  /// CombineStreams
  // Used For => Stream should have State, Failure, Data

  // It will return only true if Both Streams has value not error
  Stream<bool> get isFormValidate$ =>
      Observable.combineLatest([email$, password$], (values) => true);

  Observable<Map<dynamic, dynamic>>
      get signInComined$ => Observable.combineLatest3(
          _actionState$,
          _onFailure$,
          _authUser$,
          (ActionState state, Failure failed, AuthUser user) =>
              {ActionState: state, Failure: failed, AuthUser: user});

  SIgnInBloc({@required this.dataManager}) {
    authRepo = AuthRepository();
  }
  void setEmail(String email) => _emailSubject.sink.add(email);
  void setPassword(String password) => _passwordSubject.sink.add(password);

//  void makeWebSocketConnection() {
//    // Make Connection
//    webSocket.onConnection(() {
//      ////print("Connected---------------");
//    });
//  }

  void makeInitialState() {
    ////print("Called Initial");
//    reset();
    _actionStateSubject.add(ActionState.INITIAL);
  }

  void onError() {
    _emailSubject.sink.addError('Please enter a name');
    _passwordSubject.sink.addError('Please enter a password');
  }

  void reset() {
    _emailSubject.add('');
    _passwordSubject.add('');
  }

  Future<ResponseFlags> onVerifyEmail({String email}) async {
    final ResponseFlags f = await authRepo.verifyEmail(email: email);
    return f ?? ResponseFlags();
  }

  Future<ResponseFlags> onResetPassword({String password, String otp}) async {
    final ResponseFlags f =
        await authRepo.onResetPassword(password: password, otp: otp);
    return f ?? ResponseFlags();
  }

  void _signInUpdateCombinedStream(
      ActionState state, Failure f, AuthUser user) {
    _actionStateSubject.sink.add(state);
    _failedSubject.sink.add(f);
    _authUserSubject.sink.add(user);
  }

  Future<ActionState> onSubmit(AuthenticationBloc authenticationBloc,
      {String email, String password, String fcmToken}) async {
    ActionState _state = ActionState.INITIAL;
    try {
      _actionStateSubject.sink.add(ActionState.LOADER);

      final ResponseResult _result = await authRepo.onLogin(
          userEmail: email,
          userPassword: password,
          fcmToken: fcmToken); // Data Be Like: [AuthUser, String token]
      if (_result.data is Failure) {
        // Login Failed
        _signInUpdateCombinedStream(ActionState.ERROR, _result.data, null);
        return ActionState.FAILED;
      } else if (_result.data is List) {
        final List _dataSet = _result.data;
        final AuthUser _authUser = _dataSet[0];
        final String _authToken = _dataSet[1];
        final AuthUser _getUserIfExist = await authRepo.getUser();
//        print("Authentication: ${_authUser.toJson()}");

        if (_authUser.responseStatus == CONFIRMATION_ERROR_STATUS) {
          // User need approve
          print("Confirmation Error");
          dataManager.authUser = _authUser;
          await saveAuthInfo(_authUser, _getUserIfExist);
          _signInUpdateCombinedStream(ActionState.NOT_APPROVE, null, _authUser);
          _state = ActionState.NOT_APPROVE;
        } else {
          // User is Signed succesfully
          //print("Signed Succesfully");
          dataManager.authUser = _authUser;
          dataManager.authenticationToken = _authToken;
          await saveAuthInfo(_authUser, _getUserIfExist);
          // Do Preference Stuff
          await saveAuthToken(_authToken);

          if (await didPreference() && !_authUser.user.newUser) {
            // true && !false
            // User Already has set Preference => Go to Dash
//        authenticationBloc.updateAuthState(AuthenticationState.authenticated());
//          _signinSubject.sink
//              .add(SigninState.success(newUser: _authUser.user.newUser));
            _signInUpdateCombinedStream(ActionState.SUCCESS, null, _authUser);
            _state = ActionState.SUCCESS;
          } else {
            // This Case Mostly comes, when a verified user did login into another device
            // User has to set preference for that device

            _signInUpdateCombinedStream(
                ActionState.PRODUCT_PREFER, null, _authUser);
            _state = ActionState.PRODUCT_PREFER;
          }
//          _signinSubject.sink
//              .add(SigninState.success(newUser: _authUser.user.newUser));
        }
      }
    } catch (e) {
      print("Error In onLogin Bloc: ${e.toString()}");

      _signInUpdateCombinedStream(
          ActionState.ERROR, Failure(responseMessage: e.toString()), null);
    }
    return _state;
  }

  disclose() {
    _emailSubject.close();
    _passwordSubject.close();
//    _actionStateSubject.close();
//    _authUserSubject.close();
//    _failedSubject.close();
  }

  void closeEmailStream() {
    ////print("EMail Stream CLosed");
  }

  Future<void> saveAuthInfo(AuthUser authUser, AuthUser existUser) async {
    ////print(existUser);
    if (existUser != null) {
      if (existUser.user.userId != authUser.user.userId) {
        // If Both userId's are not same then
        // Just Delete Previous Existing Record and Insert New One
        final delete = await authRepo.deleteUser(userId: existUser.user.userId);
        final bool _clearShared = await clearSharedPreference();
        final int deleteProduct = await removeAllProduct();

        print("Detect Another User Signing In\nClearing All Data");
        print("Delete Old User Status: $delete");
        print("Delete Old User Preference: $_clearShared");
        print("Delete Old User Product Settings: $deleteProduct");
      }
    }
    int result = await authRepo.onSaveUserInfoToDevice(authUser: authUser);
    ////print('Succesfully Save Data: ${result.toString()}');
  }

  Future<bool> didPreference() async => await authRepo.getPreferValue();

  Future<bool> clearSharedPreference() => authRepo.clearSharedData();

  Future<int> removeAllProduct() => authRepo.deleteAllProduct();

  Future<bool> saveAuthToken(String token) async =>
      await authRepo.saveAuthToken(token);
}

enum VerifyState { INITIAL, LOADING, SUCCESS, FAILED, ERROR }
