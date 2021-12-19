//import 'package:rxdart/rxdart.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_model.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/commonModel/response_flags.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/repository/authRepository/auth_repository.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/auth_state.dart';
//
//class AuthenticationBloc extends DataManager {
//  final authenticationRepo = AuthRepository();
//
//  final PublishSubject<String> _authSubject = PublishSubject<String>();
//
//  Observable<String> get authenticate$ => _authSubject.stream;
//
//  void dispose() {
//    _authSubject.close();
//  }
//
//  Future<AuthModel> getUserData() async {
//    // Getting List Users From Device Data
//    List<Map<String, dynamic>> userInfo =
//        await authenticationRepo.readUserInfoFromDevice();
//    return AuthModel.fromJsonSqlflite(userInfo[0]);
//  }
//
//  autoAuthenticate() async {
//    // Adding APP STarted Value to Stream => So That Splash Screen Will be Displayed
//    //print("SPLASH APP STARTED");
////    _authSubject.add(APP_STARTED);
//
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
//      // Casting Map to AUthModel
//      authModel = AuthModel.fromJsonSqlflite(userData);
//      //print("AUTHENTICATED USER");
//
//      // Adding Authenticated to authSubject Stream
//      _authSubject.sink.add(AUTHENTICATED);
//    } else {
//      // User IS Not Available
//
//      //print("NOT AUTHENTICATED USER");
//      //print("Getting AuthModel Data: $authModel");
//
//      _authSubject.sink.add(NOT_AUTHENTICATED);
//    }
//  }
//
//  Future<int> logout() async {
//    int userId = int.parse(authModel.userData.userId);
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
