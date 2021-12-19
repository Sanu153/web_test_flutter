import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/table_columns.dart';

class AuthModel {
  String status;
  String authToken;
  String message;
  UserModel userData;

  AuthModel({this.status, this.authToken, this.userData, this.message});

  set newUser(bool d) {
    userData.newUser = d;
  }

  AuthModel.fromJson(Map<String, dynamic> json) {
    //print("JSON AUTH DATA IN MODEL: $json");
    status = json['status'];
    message = json['message'];
    authToken = json['authToken'];
    userData =
    json['userData'] != null ? UserModel.fromJson(json['userData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['authToken'] = this.authToken;
    if (this.userData != null) {
      data['userData'] = this.userData.toJson();
    }
    return data;
  }

  AuthModel.onLoginFailed(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJsonSqlFlite() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data[UserTableHelper.userToken] = this.authToken;
    //print("User Id From Model: ${this.userData.userId}");
    if (this.userData != null) {
      data[UserTableHelper.userName] = this.userData.name;
      data[UserTableHelper.userId] = this.userData.userId;
      data[UserTableHelper.userEmail] = this.userData.email;
      data[UserTableHelper.newUser] = this.userData.newUser ? 1 : 0;
    }
    return data;
  }

  AuthModel.fromJsonSqlflite(Map<String, dynamic> json) {
    final String userName = json['userName'];
    final String userEmail = json['userEmail'];
    final String userMobile = json['userMobile'];
    final String userId = json['userId'];
    final int nw = json['newUser'];
    //print("new User: $nw");
    final bool newUser = nw == 1 ? true : false;
    //print("Aftre New User: $newUser");

    final Map<String, dynamic> userInfo = {
      "userId": userId,
      "name": userName,
      "registeredId": userId,
      "mobile": userMobile,
      "email": userEmail,
      "newUser": newUser
    };

    status = 'success';
    authToken = json['userToken'];
    userData = json['userToken'] != '' ? UserModel.fromJson(userInfo) : null;
  }
}
