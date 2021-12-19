import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/auth_state.dart';

class AuthenticationState {
  final String authenticated;
  AuthenticationState.initial({this.authenticated = APP_STARTED});

  AuthenticationState.authenticated({this.authenticated = AUTHENTICATED});

  AuthenticationState.newUser({this.authenticated = 'NEW_USER'});

  AuthenticationState.failed({this.authenticated = UN_AUTHENTICATED});

  AuthenticationState.signedOut({this.authenticated = LOGOUT});

  AuthenticationState.isSkip({this.authenticated = 'NOT_SKIPPED'});

  AuthenticationState.notApproved({this.authenticated = 'NOT_APPROVED'});

  AuthenticationState.loader({this.authenticated = AUTH_LOADER});
}
