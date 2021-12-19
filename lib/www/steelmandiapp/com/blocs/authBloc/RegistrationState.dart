class RegistrationState {
  final String authenticated;

  RegistrationState.initial({this.authenticated = 'INITIAL'});

  RegistrationState.success({this.authenticated = 'SUCCESS'});

  RegistrationState.loading({this.authenticated = 'LOADING'});

  RegistrationState.failed({this.authenticated = 'FAILED'});

  RegistrationState.newUser({this.authenticated = 'NEW_USER'});

  RegistrationState.oldUser({this.authenticated = 'OLD_USER'});

  RegistrationState.dialog({this.authenticated = 'DIALOG'});
}
