import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/verificationBloc/otp_state.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/authRepository/auth_repository.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart';

class OtpBloc {
  AuthRepository authRepo;
  final DataManager dataManager;
  BehaviorSubject<List<Object>> _resendOtpSubject =
  BehaviorSubject<List<Object>>();

  OtpBloc({this.dataManager}) {
    authRepo = AuthRepository();
  }

  Observable<List<Object>> get resendOtp$ => _resendOtpSubject.stream;

  // Resend OTP
  Future<ResponseFlags> onResendOTP({@required String email}) async {
    _resendOtpSubject.add([OtpState.LOADING, null]);
    final ResponseFlags _responseFlag =
    await authRepo.onResendOTP(email: email);
//    await Future.delayed(Duration(seconds: 2));
    if (_responseFlag == null) {
      //print("Internal Error");
      _resendOtpSubject.add([OtpState.ERROR, null]);
    } else if (_responseFlag.responseStatus == SUCCESS_STATUS) {
      _resendOtpSubject.add([OtpState.SUCCESS, _responseFlag]);
    } else {
      _resendOtpSubject.add([OtpState.FAILED, _responseFlag]);
    }
    return _responseFlag;
  }

  // Verify OTP
  Future<Map> onOTPVerify(
      {@required String email, @required String otpCode}) async {
    final Map<dynamic, dynamic> _resultSet = {};
    _resultSet[ActionState] = ActionState.LOADER;

    final List<dynamic> dataSet =
        await authRepo.onOtpVerify(email: email, otpCode: otpCode);

    /// DataSet be like = [AuthUser _authUser, String authTokne]
    AuthUser _authUser = dataSet[0];
    final String authToken = dataSet[1];
    //print("AUTH TOKEN IN OTP: $authToken");
    final String status = _authUser.responseStatus;
    if (_authUser == null) {
      //print("Internal Error");
//      _otpVerifySubject.add([null, null]);
      _resultSet[ActionState] = ActionState.ERROR;
    } else if (status == VALIDATION_ERROR_STATUS) {
      // Otp Validation Error
      dataManager.authUser = _authUser;
//      _otpVerifySubject.add([RegistrationState.failed(), _authUser]);
      _resultSet[ActionState] = ActionState.FAILED;
      _resultSet[AuthUser] = _authUser;
    } else if (status == SUCCESS_STATUS && _authUser.user.newUser) {
      // Status => SUCCESS && NewUser => true
      // SHow Preference Screen
      dataManager.authUser = _authUser;
      await updateUserData(_authUser, authToken);

//      _otpVerifySubject.add([RegistrationState.success(), _authUser]);
      _resultSet[ActionState] = ActionState.SUCCESS;
      _resultSet[AuthUser] = _authUser;
    }
    return _resultSet;
  }

  void closeDialog() {
//    _otpVerifySubject.add([RegistrationState.initial(), null]);
  }

//  void openDialog() {
//    _otpVerifySubject.add([RegistrationState.dialog(), null]);
//  }

  void close() {
//    _otpVerifySubject.add([RegistrationState.initial(), null]);
  }

  Future<void> updateUserData(AuthUser authUser, String token) async {
    final int resultCount = await authRepo.updateNewUser(authUser: authUser);
    //print("User Updated Status: $resultCount");
    if (resultCount != 0) {
      bool result = await authRepo.saveAuthToken(token);
      dataManager.authenticationToken = token;
      //print("Succesfully: Saved Token : $result");
    }
  }
}
