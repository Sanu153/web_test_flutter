import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/RegistrationState.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/register_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/message_notifier.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/my_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart'
    show VALIDATION_ERROR_STATUS;
import 'package:steelmandi_app/www/steelmandiapp/com/utils/validation/auth_validation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/verify/otp_verification.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/observer.dart';

class MyRegisterScreen extends StatefulWidget {
  @override
  _MyrefisterScreenState createState() => _MyrefisterScreenState();
}

class _MyrefisterScreenState extends State<MyRegisterScreen>
    with AuthValidation {
  RegisterBloc _registerBloc;

  bool _isCheckedTerm = true;

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPaswordController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  final double minValue = 8.0;
  bool obscureText = true;

  String _errorText;
  String _confirmErrorText;
  bool _autoValidate = false;
  bool inValid = false;

  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 14,
  );

  @override
  void didChangeDependencies() {
    SystemConfig.makeStatusBarVisible();

    super.didChangeDependencies();
    _registerBloc = Provider.of(context).fetch(RegisterBloc);
    //print(_registerBloc);
  }

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }

  void _onEditEmail() {}

  void resetForm() {
    _passwordController.text = '';
    _confirmPaswordController.text = '';
    _firstNameController.text = '';
    _lastNameController.text = '';
    _mobileController.text = '';
    _emailController.text = '';
  }

  void _onSubmit() async {
    if (_globalKey.currentState.validate() && !inValid) {
      String fcmToken =
          await Provider.of(context).notificationManager.getFcmToken();
      try {
        String fname = _firstNameController.text;
        String lname = _lastNameController.text;
        String email = _emailController.text;
        String mobile = _mobileController.text;
        String password = _passwordController.text;
        String category = 'Trader';
        AuthUser _authUser = await _registerBloc.onSubmit(
            firstName: fname.trim(),
            lastName: lname,
            email: email.trim(),
            mobileNo: mobile.trim(),
            password: password.trim(),
            fcmToken: fcmToken,
            category: category);
        resetForm();

        // MAke AuthBlock
        // Reg Bloc

//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (BuildContext context) => MyLoaderScreen()));
      } catch (e) {
        //print(e);
      }
    } else {
      setState(() {
        inValid = _isCheckedTerm ? false : true;
        _autoValidate = true;
      });
    }
  }

  Widget _firstName() {
    return TextFormField(
      controller: _firstNameController,
      validator: usernameValidator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          labelText: 'First Name',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _lastName() {
    return TextFormField(
      controller: _lastNameController,
//      validator: usernameValidator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          labelText: 'Last Name',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _email() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.text,
      validator: validateEmail,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          labelText: 'Email',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _mobile() {
    return TextFormField(
      controller: _mobileController,
      validator: mobileValidator,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          labelText: 'Mobile No',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _password() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      validator: validatePassword,
      onChanged: _onChangedPassword,
      decoration: InputDecoration(
          errorText: _errorText,
          suffixIcon: FlatButton(
              child: Text(
                obscureText ? 'SHOW' : 'HIDE',
                style: TextStyle(fontSize: 12.0, color: Colors.black87),
              ),
              onPressed: () {
                setState(() {
                  obscureText = obscureText ? false : true;
                });
              }),
          labelText: 'Password',
          errorStyle: _errorStyle,
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _confirmPassword() {
    return TextFormField(
      controller: _confirmPaswordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      validator: makeConfirmPassword,
      onChanged: _onChangedConfirmPassword,
      decoration: InputDecoration(
          errorText: _confirmErrorText,
          labelText: 'Confirm Password',
          errorStyle: _errorStyle,
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildTermsConditions() {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isCheckedTerm,
          checkColor: _isCheckedTerm ? Colors.white : Colors.transparent,
          onChanged: (value) {
            setState(() {
              _isCheckedTerm = value;
            });
          },
          activeColor: Theme.of(context).primaryColorDark,
        ),
        FlatButton(
          child: Text(
            "Terms and Conditions",
            style: TextStyle(
                color: inValid ? Colors.red : Colors.blueGrey[700],
                fontSize: 16.0),
          ),
          onPressed: () {
            setState(() {
              inValid = !inValid;
              _isCheckedTerm = _isCheckedTerm ? false : true;
            });
          },
        )
      ],
    );
  }

  Widget _buildForm(BuildContext context, AuthUser authUser) {
    return Padding(
      padding: EdgeInsets.all(minValue * 3),
      child: Form(
        autovalidate: _autoValidate,
        key: _globalKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
//
            Container(
              child: authUser != null &&
                      authUser.responseStatus == VALIDATION_ERROR_STATUS
                  ? MyMessageNotifier(
                      message: authUser.responseMessage,
                      onClose: () {
                        _registerBloc.closeDialog();
                      },
                    )
                  : Container(),
            ),
            _divider(),
            _buildHeader(),
            _divider(),
            _firstName(),
            _divider(),
            _lastName(),

            _divider(),

            _email(),
            _divider(),
            _mobile(),
            _divider(),
            _password(),
            _divider(),
            _confirmPassword(),
            _divider(),
            _buildTermsConditions()
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return SizedBox(
      height: 15,
    );
  }

  Widget _buildHeader() {
    final t = Theme.of(context).textTheme.headline;
    return Text(
      "Create an account",
      style: t.apply(fontSizeDelta: 1, fontWeightDelta: 1),
    );
  }

  Widget _buildRegBtn(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: EdgeInsets.all(minValue * 2),
        color: Theme.of(context).accentColor,
        onPressed: _onSubmit,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            "Submit",
            style: Theme.of(context).textTheme.title.apply(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterBody({BuildContext context, AuthUser authUser}) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
          elevation: 0.0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(child: _buildForm(context, authUser)),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildRegBtn(context))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Observer<List<Object>>(
      stream: _registerBloc.registratrion$,
      onWaiting: (context) {
        //print("Waiting Executed");
        return MyLoaderScreen();
//        return _buildRegisterBody(context: context, authUser: null);
      },
      onSuccess: (context, List dataList) {
        final RegistrationState dataState = dataList[0];
        final AuthUser user = dataList[1];

        //print(dataState.authenticated);
        if (dataState.authenticated ==
            RegistrationState.loading().authenticated) {
          return MyLoaderScreen(
            title: "Validating...",
          );
        } else if (dataState.authenticated ==
            RegistrationState.success().authenticated) {
          return MyOTPVerifyScreen(
            data: user.user.email,
            notifierType: 'email',
            visibleNotifier: true,
            notifierMessage: user.responseMessage,
          );
//          return _buildRegisterBody(context: context, status: 'success');
        } else if (dataState.authenticated ==
            RegistrationState.failed().authenticated) {
          return _buildRegisterBody(context: context, authUser: user);
        } else {
//          return MyLoaderScreen();
          return _buildRegisterBody(context: context);
        }
      },
      onError: (context) {
        //print("On Error");
        return _buildRegisterBody(context: context);
      },
    );
  }

  String makeConfirmPassword(String confrim) {
    String password = _passwordController.text;
    if (confrim.isEmpty) {
      return 'Please enter confirm password';
    } else if (password != confrim) {
      return 'Passwords not matched';
    }
  }

  void _onChangedPassword(String value) {
    String msg = validatePassword(value);

    setState(() {
      _errorText = msg;
    });
  }

  void _onChangedConfirmPassword(String value) {
    setState(() {
      String password = _passwordController.text;
      if (value.isEmpty) {
        _confirmErrorText = 'Please enter confirm password';
      } else if (password != value) {
        _confirmErrorText = 'Passwords not match';
      } else {
        _confirmErrorText = null;
      }
    });
  }
}
