import 'dart:io';

import 'package:meta/meta.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/authServices/auth_service.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/database_helper.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/shared_preference_data.dart';

class AuthRepository {
  AuthService authService;
  DatabaseHelper databaseHelper;

  AuthRepository() {
    authService = AuthService();
    databaseHelper = DatabaseHelper();
  }

  /// Login or Registration
  Future<ResponseResult> onLogin(
          {@required String userEmail,
          @required String userPassword,
          String fcmToken}) =>
      authService.onLogin(
          userEmail: userEmail, userPassword: userPassword, fcmToken: fcmToken);

  Future<AuthUser> onRegister({@required Map<String, dynamic> userMap}) =>
      authService.onRegister(userMap: userMap);

  // Sign Out
  Future<ResponseResult> onSignOutService(String token, String fcm) =>
      authService.onSignOut(token, fcm);

  /// OTP Generate Section
  Future<List<dynamic>> onOtpVerify(
          {@required String email, @required String otpCode}) =>
      authService.onOtpVerify(email: email, otpCode: otpCode);

  Future<ResponseFlags> onResendOTP({@required String email}) =>
      authService.onResendOTP(email: email);

  /// Forgot Password or Reset Password or Change Password
  Future<ResponseFlags> onForgotPass({@required String email}) =>
      authService.onForgotPassword(email: email);

  Future<int> onSaveUserInfoToDevice({@required AuthUser authUser}) =>
      databaseHelper.insert(authUser);

  // Get user Information
  Future<List<Map<String, dynamic>>> readUserInfoFromDevice() =>
      databaseHelper.queryAllRows();

  Future<AuthUser> getUser() => databaseHelper.getUser();

  // Update SqlFLite Db User
  Future<int> updateDBUser(Map<String, dynamic> row) =>
      databaseHelper.update(row);

  // Update New User To Local Device
  Future<int> updateNewUser({@required AuthUser authUser}) =>
      databaseHelper.updateNewUser(authUser);

  /// Delete All Products
  Future<int> deleteAllProduct() => databaseHelper.removeAllProduct();

  /// Delete All User
  Future<int> deleteAllUser() => databaseHelper.removeAllUser();

  // Update New User Data To Local Device
  Future<int> deleteUser({@required int userId}) =>
      databaseHelper.delete(userId);

  // Make Email Verification
  Future<bool> saveEmail({@required String email}) =>
      SharedData.saveEmail(email);

  Future<String> getEmail() => SharedData.getEmail();

  // Verify Email n Reset  Password
  Future<ResponseFlags> verifyEmail({@required String email}) =>
      authService.onForgotPassword(email: email);

  Future<ResponseFlags> onResetPassword(
          {@required String password, @required String otp}) =>
      authService.onResetPassword(otpCode: otp, password: password);

  // User Profile Info
  Future<ResponseResult> getUserProfileInfo(String token) =>
      authService.getUserProfileInfo(token);

// User Profile Update
  Future<ResponseResult> updateUserProfile(
          String token, Map<String, dynamic> data) =>
      authService.updateUserProfile(token, data: data);

// User Update Password
  Future<ResponseResult> updateUserPassword(String token,
          {String oldPass, String newPass}) =>
      authService.updateUserPassword(token,
          newPassword: newPass, oldPassword: oldPass);

  // User Update User Profile Image
  Future<ResponseResult> updateUserProfileAvatar(String token, File file) =>
      authService.updateUserProfileAvatar(token, file);

  // For LogOut
  Future<bool> loggedOut() => SharedData.getLoggedOut();

  // Skip Preferences
  Future<void> saveSkipInfo(bool skip) =>
      SharedData.saveSkipInfo(skip); // Skip Preferences
  Future<bool> getSkipInfo() => SharedData.getSkipInfo();

  // Token Setup
  Future<bool> saveAuthToken(String token) => SharedData.saveAuthToken(token);

  Future<String> getAuthToken() => SharedData.getAuthToken();

  // Preference Configuration
  Future<bool> savePreferValue(bool value) => SharedData.savePreferValue(value);

  Future<bool> getPreferValue() => SharedData.getPreferValue();

  Future<bool> clearSharedData() => SharedData.clear();
}
