import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/signin_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/message_notifier.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/appbar/unauth_appbar.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/my_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/validation/auth_validation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/register_form_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/resetViews/forgot_password.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/verify/otp_verification.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/preference_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/homeViews/landscape_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';

class MyloginScreen extends StatefulWidget {
  @override
  _MyloginScreenState createState() => _MyloginScreenState();
}

class _MyloginScreenState extends State<MyloginScreen> with AuthValidation {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final double _minPadding = 8.0;
  SIgnInBloc _loginBloc;

  bool _obSecureText = true;

//  bool _isLoading = true;

  bool loginType = true; // Email / Phone
  bool _isLoginFailed = false;
  bool _autoValidate = false;
  String emailHolder = '';
  ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    SystemConfig.makeStatusBarVisible();
    SystemConfig.makeDevicePotrait();
    _loginBloc = Provider.of(context).fetch(SIgnInBloc);
    _productBloc = Provider.of(context).fetch(ProductBloc);
    _loginBloc.makeInitialState();
//    _loginBloc.makeInitialState();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //print("Called Disclosed()---------------------------------------------");
    _loginBloc.disclose();
    super.dispose();
  }

  String _onloginWithPhoneChange(String value) {}

  void _reset() {
    emailHolder = _emailController.text;
    _emailController.text = "";
    _passwordController.text = "";
  }

  void _onLoginWithEmailClick() async {
    if (_globalKey.currentState.validate()) {
      AuthenticationBloc authenticationBloc =
          Provider.of(context).fetch(AuthenticationBloc);
      String fcmToken =
          await Provider.of(context).notificationManager.getFcmToken();
      //print("FCM TOKEN: $fcmToken");
      String email = _emailController.text;
      String password = _passwordController.text;
      ActionState _state = await _loginBloc.onSubmit(authenticationBloc,
          email: email.trim(), password: password, fcmToken: fcmToken);
      _reset();
      print(_state);
      if (_state == ActionState.SUCCESS) {
//        _loginBloc.disclose();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MyLandScapeHomeScreen(
                      productBloc: _productBloc,
                    )),
            (Route<dynamic> route) => false);
      } else if (_state == ActionState.NOT_APPROVE) {
        final child = MyOTPVerifyScreen(
          notifierMessage:
              "You have to confirm your email address before continuing.",
          data: emailHolder,
          notifierType: 'email',
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => child),
            (Route<dynamic> route) => false);
      } else if (_state == ActionState.PRODUCT_PREFER) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MyprefernceScreen(
                      wilExit: false,
                    )),
            (Route<dynamic> route) => false);
      }

//      _loginBloc.reset();
    } else {
      setState(() => _autoValidate = true);
//      _loginBloc.onError();
//      Utility.showSnacks(msg: "Invalid Form Data", context: context);
    }
  }

  void _onLoginWithPhoneClick() {
    if (_globalKey.currentState.validate()) {
      //print("OTP Sent to ${_mobileController.text}");
    }
  }

  Widget _loginWithPhone() {
    TextStyle subhead = Theme.of(context).textTheme.subhead;
    return Form(
      key: _globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getDivider(),
          Center(
            child: Text(
              "Sign in with your phone number",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            title: TextFormField(
              controller: _mobileController,
              onChanged: _onloginWithPhoneChange,
              style: subhead,
              keyboardType: TextInputType.number,
              autofocus: false,
              validator: mobileValidator,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_iphone),
                labelText: "Phone No",
                labelStyle: subhead,
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDivider() {
    return SizedBox(
      height: 15,
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(_minPadding),
      child: Column(
        children: <Widget>[
          Text(
            CoreSettings.appName,
            style: Theme.of(context).textTheme.display1.apply(
                color: Theme.of(context).primaryColorDark, fontWeightDelta: 1),
            textAlign: TextAlign.center,
          ),
          getDivider(),
          Text(
            "Log in to your account",
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }

  Widget _buildEmailLogin() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 2 * _minPadding, horizontal: _minPadding * 2),
      child: Form(
        key: _globalKey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "Sign in with your email",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            getDivider(),
            _buildEmailField(),
            getDivider(),
            _buildPasswordField(),
            getDivider(),
            getDivider(),
            _buildForgotPassword(),
            getDivider(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    TextStyle subhead = Theme.of(context).textTheme.title;

    return TextFormField(
      controller: _emailController,
      style: subhead,
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      autofocus: false,
      decoration: InputDecoration(
//              prefixIcon: Icon(Icons.person),
        labelText: "Email",
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(2)),
      ),
    );
  }

  Widget _buildPasswordField() {
    TextStyle subhead = Theme.of(context).textTheme.title;
    return TextFormField(
      controller: _passwordController,
      style: subhead,
      validator: validateLoginPass,
      obscureText: _obSecureText,
      decoration: InputDecoration(
//                prefixIcon: Icon(Icons.lock),
          suffixIcon: FlatButton(
            onPressed: () {
              setState(() {
                _obSecureText = _obSecureText ? false : true;
              });
            },
            child: Text(
              _obSecureText ? 'SHOW' : 'HIDE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          labelText: "Password",
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87),
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 14,
          )),
    );
  }

  Widget _buildLoginBtn(bool isLoading) {
    final t = Theme.of(context).textTheme.title.apply(color: Colors.white);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: _minPadding * 2),
      child: RaisedButton(
        onPressed: isLoading
            ? null
            : loginType ? _onLoginWithEmailClick : _onLoginWithPhoneClick,
        textColor: Colors.white,
        disabledElevation: 0.0,
        disabledColor: Colors.red[300],
        elevation: 0.0,
        child: isLoading
            ? MyComponentsLoader(
                color: Colors.white,
              )
            : Text(
                "${loginType ? 'LOGIN' : 'SEND OTP'}",
                style: t,
              ),
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.all(_minPadding * 2),
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(_minPadding * 4))),
      ),
    );
  }

  Widget _buildForgotPassword() {
    TextStyle subhead = Theme.of(context).textTheme.subhead;
    return InkWell(
      onTap: _onForgotPassword,
      child: Text(
        "Forgot password?",
        style: subhead,
      ),
    );
  }

  void _onForgotPassword() {
//    final dialogWidth = MediaQuery.of(context).size.width * 2 / 2;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyForgotPassward()));
  }

  Widget _buildInitialState(Failure failure, bool isLoading) {
    return SafeArea(
      child: Scaffold(
        appBar: UnAuthenticateAppbar(
          title: '',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _minPadding,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView(
                children: <Widget>[
                  _buildTitle(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2 * _minPadding, horizontal: _minPadding),
                    child: failure != null
                        ? MyMessageNotifier(
                            message:
                                failure.responseMessage ?? "Some Error Occured",
                            onClose: () {
                              _loginBloc.makeInitialState();
                            },
                          )
                        : Container(),
                  ),
//              getDivider(),
                  loginType ? _buildEmailLogin() : _loginWithPhone(),
                  getDivider(),
                  getDivider(),
                  _buildLoginBtn(isLoading),
                  getDivider(),
                  getDivider(),
//                  MyLoginOption(
//                    isSelected: loginType,
//                    onPressed: () {
//                      //print("On Pressed");
//                      setState(() {
//                        loginType = loginType ? false : true;
//                      });
//                    },
//                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("New User"),
                      SizedBox(
                        width: 8.0,
                      ),
                      GestureDetector(
                        onTap: _onSignupTextTap,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            "Sign Up Here",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: StreamMania<AuthUser>(
        stream: _loginBloc.signInComined$,
        onInitial: (context) {
          return _buildInitialState(null, false);
        },
        onWaiting: (context) {
          return _buildInitialState(null, true);
        },
        onError: (context, Failure failed) {
          return _buildInitialState(failed, false);
        },
        onFailed: (context, Failure failed) {
          return _buildInitialState(failed, false);
        },
        onGeneralState: (context, user, state) {
          return MyLoaderScreen(
            title: 'Validating settings',
          );
        },
        onSuccess: (context, AuthUser user) {
          return MyLoaderScreen();
        },
      ),
    );
  }

  void _onSignupTextTap() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => MyRegisterScreen()));
  }
}
