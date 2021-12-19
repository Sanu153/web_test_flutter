import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/table_columns.dart';

class UserModel {
  int userId;
  String email;
  String firstName;
  String lastName;
  String mobileNo;
  bool newUser;
  String gender;
  String dob;
  String citizenship;
  String city;
  String state;
  String country;
  String pin;
  String address;
  String tin;
  String imageUrl;
  String userCategory;
  String name;

  set updateNewUser(bool value) {
    newUser = value;
  }

  UserModel(
      {this.imageUrl,
      this.userCategory,
      this.userId,
      this.email,
      this.firstName,
      this.lastName,
      this.mobileNo,
      this.newUser,
      this.gender,
      this.dob,
      this.citizenship,
      this.city,
      this.state,
      this.country,
      this.pin,
      this.address,
      this.tin});

  UserModel.fromJson(Map<String, dynamic> json) {
//    print("UserModel FROM JSON: $json");
    userId = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNo = json['mobile'];
    newUser = json['new_user'];
    gender = json['gender'];
    dob = json['dob'];
    citizenship = json['citizenship'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pin = json['pin'];
    address = json['address'];
    tin = json['tin'];
    imageUrl = json['photo_url'];

    userCategory = json['user_category'];

    name = json['name'] == null
        ? "${firstName ?? ''}" + ' ' + "${lastName ?? ''}"
        : json['name']; //json['name'] coming from local Db
//    newUser = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userId;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobileNo;
    data['new_user'] = this.newUser;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['citizenship'] = this.citizenship;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pin'] = this.pin;
    data['address'] = this.address;
    data['tin'] = this.tin;
    data['user_ategory'] = this.userCategory;
    data['photo_url'] = this.imageUrl;
    return data;
  }

  Map<String, dynamic> toJsonLocalData() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[UserTableHelper.userName] = this.name;
    data[UserTableHelper.userId] = this.userId;
    data[UserTableHelper.userEmail] = this.email;
    data[UserTableHelper.userMobile] = this.mobileNo;
    data[UserTableHelper.newUser] = this.newUser ? 1 : 0;

    return data;
  }

  UserModel.fromJsonScqlflite(Map<String, dynamic> json) {
//    //print("From Json: $json");
    this.name = json['userName'];
    this.email = json['userEmail'];
    this.mobileNo = json['userMobile'];
    this.userId = json['userId'];
    final int nw = json['newUser'];
//    //print("new User: $nw");
    this.newUser = nw == 1 ? true : false;

//    final Map<String, dynamic> userInfo = {
//      "userId": userId,
//      "name": userName,
//      "registeredId": userId,
//      "mobile": userMobile,
//      "email": userEmail,
//      "newUser": newUser
//    };
  }
}
