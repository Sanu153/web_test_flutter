import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/auth_state.dart';

class SigninState {
  final String authenticated;
  bool newUser = false;

  SigninState.initial({this.authenticated = INITIAL_LOGIN});

  SigninState.success(
      {this.authenticated = SUCCESS_LOGIN, this.newUser = false});

  SigninState.loading({this.authenticated = LOADING_LOGIN});

  SigninState.notApprove({this.authenticated = NOT_APPROVE_LOGIN});

  SigninState.failed({this.authenticated = FAILED_LOGIN});

  SigninState.setPreference({this.authenticated = SET_PREFERENCE});
}
