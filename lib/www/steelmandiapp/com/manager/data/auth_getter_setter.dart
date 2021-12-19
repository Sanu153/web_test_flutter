import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class AuthGetterSetter {
  String authenticationToken;

//  AuthModel authModel;

  UserModel userModel;

  AuthUser authUser;

  CoreSettings _coreSettings;

  CoreSettings get coreSettings => _coreSettings ?? CoreSettings();

  set coreSettings (CoreSettings settings) {
    _coreSettings = settings;
  }
}
