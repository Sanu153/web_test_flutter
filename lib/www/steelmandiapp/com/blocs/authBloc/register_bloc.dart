import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/RegistrationState.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/authRepository/auth_repository.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart'
    show VALIDATION_ERROR_STATUS;

class RegisterBloc {
  final authRepo = AuthRepository();
  final DataManager dataManager;
  BehaviorSubject<String> _verifySubject = BehaviorSubject<String>();
  BehaviorSubject<List<Object>> _registerSubject =
      BehaviorSubject<List<Object>>.seeded([RegistrationState.initial(), null]);

  RegisterBloc({this.dataManager});

  Observable<String> get verifyEmail$ => _verifySubject.stream;

  Observable<List<Object>> get registratrion$ => _registerSubject.stream;

  void close() {
    _registerSubject.add([RegistrationState.initial(), null]);
    //print("Closeddd");
//    _registerSubject.close();
  }

  Future<AuthUser> onSubmit(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String mobileNo,
      @required String category,
      String fcmToken,
      @required String password}) async {
    AuthUser _authUser;
    try {
      _registerSubject.add([RegistrationState.loading(), null]);

      Map<String, dynamic> mapData = {
        "user": {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "mobile": mobileNo,
          "password": password
        },
        "fcm_token": fcmToken
      };

      _authUser = await authRepo.onRegister(userMap: mapData);
      if (_authUser == null) {
        // Internal Error
        //print("Internal Error");
        _registerSubject.add([
          RegistrationState.failed(),
          AuthUser(
              responseMessage: "Internal Server Error",
              responseStatus: VALIDATION_ERROR_STATUS)
        ]);
      } else if (_authUser.responseStatus == VALIDATION_ERROR_STATUS) {
        dataManager.authUser = _authUser;
        _registerSubject.add([RegistrationState.failed(), _authUser]);
      } else {
        await _removeExistingDataOnDevice();
        dataManager.authUser = _authUser;
        await createUserData(_authUser);
        _registerSubject.add([RegistrationState.success(), _authUser]);
      }
    } catch (e) {
      print("Error in Register BLOC: ${e.toString()}");
    }

    return _authUser;
  }

  void closeDialog() {
    _registerSubject.add([RegistrationState.initial(), null]);
  }

  Future<ResponseFlags> onVerifyEmailForRegistration({String email}) async {
    _verifySubject.add('loading');
    ResponseFlags result;
    result = await authRepo.verifyEmail(email: email);

    return result;
  }

  // Email Operations
  Future<bool> saveEmail({String email}) async {
    //print(email);
    return await authRepo.saveEmail(email: email);
  }

  /// When user registered successfully, remove all Settings, Preferences and UserData On Device If Exist
  Future<void> _removeExistingDataOnDevice() async {
    // Clear On Cache
    dataManager.authUser = null;
    dataManager.authenticationToken = "";
//    dataManager.mapMarketIdWithName = null;
//    dataManager.
    final bool _shareClear = await authRepo.clearSharedData();
    if (_shareClear) {
      print("All Shared Preference Data Has Been Cleared");
    }
    final int _clearProductData = await authRepo.deleteAllProduct();
    if (_clearProductData != 0) {
      print("All Products Removed");
    }
    final int _clearExistingUser = await authRepo.deleteAllUser();

    if (_clearExistingUser != 0) {
      print("All Users Removed");
    }
  }

  // Update User Data
  Future<void> createUserData(AuthUser authUser) async {
    final int resultCount =
        await authRepo.onSaveUserInfoToDevice(authUser: authUser);
    print("User Created Status: $resultCount");
    if (resultCount != 0) {
      print("Successfully: Updated");
    }
  }

//  Future<void> saveAuthInfo(AuthModel model) async {
//    int result = await authRepo.onSaveUserInfoToDevice(authdata: model);
//    //print('Succesfully Save Data: ${result.toString()}');
//  }
}
