//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_model.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/commonModel/response_flags.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/repository/authRepository/auth_repository.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/auth_state.dart';
//
//class Authentication extends DataManager {
//  final authenticationRepo = AuthRepository();
//
//  Future<String> autoAuthenticate() async {
//    String state = '';
//    // Splash Screen Will Be Displayed Only For Given Second;
//    await Future.delayed(Duration(seconds: 2));
//
//    // Getting List Users From Device Data
//    List<Map<String, dynamic>> userInfo =
//        await authenticationRepo.readUserInfoFromDevice();
//
//    if (userInfo.length > 0) {
//      // Check User User Is Available
//      final Map<String, dynamic> userData = userInfo[0];
//      authModel = AuthModel.fromJsonSqlflite(userData);
//      state = AUTHENTICATED;
//    } else {
//      state = NOT_AUTHENTICATED;
//    }
//    return state;
//  }
//
//  Future<int> logout() async {
//    int userId = int.parse('1');
//    //print(userId);
//    int result = await authenticationRepo.loggedOut(userId: userId);
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.clear();
//    //print("Result is: $result}");
//    return result;
//  }
//
//  // Email Operations
//  Future<bool> saveEmail({String email}) async {
//    //print(email);
//    return await authenticationRepo.saveEmail(email: email);
//  }
//
//  Future<String> getEmail() async {
//    return await authenticationRepo.getEmail();
//  }
//
//  Future<ResponseFlags> verifyEmail({String email}) async {
//    ResponseFlags _flag = await authenticationRepo.verifyEmail(email: email);
//    if (_flag != null) {
//      bool result = await saveEmail(email: email);
//      if (result) {
//        return _flag;
//      } else {
//        //print("Server Response Generated\nBut Failed to Save In Device");
//        return null;
//      }
//    }
//    return null;
//  }
//}
