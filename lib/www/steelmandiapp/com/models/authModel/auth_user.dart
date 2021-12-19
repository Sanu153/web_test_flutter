import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/table_columns.dart';

class AuthUser {
  UserModel user;
  String responseMessage;
  String responseStatus;

  AuthUser({this.user, this.responseMessage, this.responseStatus});

  AuthUser.fromJson(Map<String, dynamic> json) {
    //print("AUth FROMJSON: $json");
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    responseMessage = json['response_message'];
    responseStatus = json['response_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['response_message'] = this.responseMessage;
    data['response_status'] = this.responseStatus;
    return data;
  }

  Map<String, dynamic> toJsonSqlFlite() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data[UserTableHelper.userToken] = this.authToken;
    print("User New: ${this.user.newUser}");
    if (this.user != null) {
      data[UserTableHelper.userName] = this.user.name;
      data[UserTableHelper.userId] = this.user.userId;
      data[UserTableHelper.userEmail] = this.user.email;
      data[UserTableHelper.userMobile] = this.user.mobileNo;
      data[UserTableHelper.newUser] = this.user.newUser ? 1 : 0;
      data[UserTableHelper.responseStatus] = this.responseStatus;
      data[UserTableHelper.responseMessage] = this.responseMessage;

      data[UserTableHelper.gender] = this.user.gender;
      data[UserTableHelper.dob] = this.user.dob;
      data[UserTableHelper.citizenship] = this.user.citizenship;
      data[UserTableHelper.city] = this.user.city;
      data[UserTableHelper.state] = this.user.state;
      data[UserTableHelper.country] = this.user.country;
      data[UserTableHelper.pin] = this.user.pin;
      data[UserTableHelper.address] = this.user.address;
      data[UserTableHelper.tin] = this.user.tin;
      data[UserTableHelper.photoURL] = this.user.imageUrl;

      data[UserTableHelper.firstName] = this.user.firstName;
      data[UserTableHelper.lastName] = this.user.lastName;
      data[UserTableHelper.middleName] = '';
    }
    return data;
  }

  AuthUser.fromJsonSqlflite(Map<String, dynamic> json) {
//    //print("AuthUser JSON From Local DB: $json");
    final String userName = json['userName'];
    final String userEmail = json['userEmail'];
    final String userMobile = json['userMobile'];
    final String userCategory = json['user_category'];
    final int userId = json['userId'];
    final String responseStatus = json['responseStatus'];
    final String responseMessage = json['responseMessage'];
    final int nw = json['newUser'];
//    print("new User: $nw");
    final bool newUser = nw == 1 ? true : false;
//    print("After New User: $newUser");

    final String photo_url = json['photoURL'];
    //print("Image URL From SqFLITE DB: $photo_url");
    final String tin = json['tin'];
    final String address = json['address'];
    final String pin = json['pin'];
    final String country = json['country'];
    final String state = json['state'];
    final String city = json['city'];
    final String citizenship = json['citizenship'];
    final String dob = json['dob'];
    final String gender = json['gender'];
    final String first_name = json['first_name'];
    final String last_name = json['last_name'];
    final String middle_name = json['middle_name']; // Not Coming Now

    final Map<String, dynamic> userInfo = {
      "id": userId,
      "name": userName,
      "mobile": userMobile,
      "email": userEmail,
      "new_user": newUser,
      "user_category": userCategory == null ? 'Trader' : userCategory,
      "middle_name": middle_name,
      "last_name": last_name,
      "first_name": first_name,
      "gender": gender,
      "dob": dob,
      "citizenship": citizenship,
      "city": city,
      "state": state,
      "country": country,
      "pin": pin,
      "address": address,
      "tin": tin,
    };

    this.responseStatus = responseStatus;
    this.responseMessage = responseMessage;
    this.user = responseStatus != UNAUTHENTICATION_STATUS
        ? UserModel.fromJson(userInfo)
        : null;
  }
}
