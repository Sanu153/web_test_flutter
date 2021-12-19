import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/signin_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/message_notifier.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/validation/auth_validation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/login_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/resetViews/forgot_otp_screen.dart';

class MyResetPasswordScreen extends StatefulWidget {
  final String data;
  final String dataType;

  MyResetPasswordScreen({this.data, this.dataType});

  @override
  _MyResetPasswordScreenState createState() => _MyResetPasswordScreenState();
}

class _MyResetPasswordScreenState extends State<MyResetPasswordScreen>
    with AuthValidation {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPaswordController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final double minValue = 8.0;
  bool obscureText = true;

  String _errorText;
  String _confirmErrorText;
  bool _autoValidate = false;
  bool isVisible = false;
  String myOtpCode = '';
  bool _hasError = false;

  SIgnInBloc _sIgnInBloc;

  bool isLoading = false;
  String responseMessage = '';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _sIgnInBloc = Provider.of(context).fetch(SIgnInBloc);
    SystemConfig.makeStatusBarVisible();
  }

  void _onSubmit() async {
    if (_globalKey.currentState.validate() && myOtpCode.length == 6) {
      setState(() {
        isLoading = true;
      });
      ResponseFlags flags = await _sIgnInBloc.onResetPassword(
          otp: myOtpCode, password: _passwordController.text);

      if (flags.responseStatus == SUCCESS_STATUS) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyloginScreen()));
        DialogHandler.showMySuccessDialog(
            context: context,
            title: flags.responseStatus,
            message: flags.responseMessage);
      } else {
        _onError(flags);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _onError(ResponseFlags flags) {
    setState(() {
      isLoading = false;
      _hasError = true;
      _passwordController.text = '';
      _confirmPaswordController.text = '';
      _otpController.text = '';
      responseMessage = flags.responseMessage;
//      final snackBar = SnackBar(content: Text(flags.responseMessage));
//
//// Find the Scaffold in the widget tree and use it to show a SnackBar.
//      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  String makeConfirmPassword(String confrim) {
    String password = _passwordController.text;
    if (confrim.isEmpty) {
      return 'Please enter confirm password';
    } else if (password != confrim) {
      return 'Passwords not match';
    }
  }

  void _onChangedPassword(String value) {
    String msg = validatePassword(value);

    setState(() {
      _errorText = msg;
    });
  }

  Widget _divider() {
    return SizedBox(
      height: 15,
    );
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

  Widget _password() {
    return ListTile(
      title: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureText,
        validator: validatePassword,
        onChanged: _onChangedPassword,
        decoration: InputDecoration(
            errorText: _errorText,
            suffixIcon: FlatButton(
                child: Text(
                  "${obscureText ? 'SHOW' : 'HIDE'}",
                  style: TextStyle(fontSize: 12.0, color: Colors.black87),
                ),
                onPressed: () {
                  setState(() {
                    obscureText = obscureText ? false : true;
                  });
                }),
            labelText: 'Password',
            errorStyle: TextStyle(fontSize: 16.0),
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
      ),
    );
  }

  Widget _confirmPassword() {
    return ListTile(
      title: TextFormField(
        controller: _confirmPaswordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscureText,
        validator: makeConfirmPassword,
        onChanged: _onChangedConfirmPassword,
        decoration: InputDecoration(
            errorText: _confirmErrorText,
            errorStyle: TextStyle(fontSize: 16.0),
            labelText: 'Confirm Password',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
      ),
    );
  }

  Widget _buildEmail() {
    final t = Theme.of(context).textTheme.title;
    final edit = Theme.of(context)
        .textTheme
        .body2
        .apply(color: Theme.of(context).backgroundColor);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: minValue * 2),
      padding: EdgeInsets.symmetric(
          vertical: minValue * 2, horizontal: minValue * 2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(minValue * 3))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("My ${widget.dataType}"),
                Padding(padding: EdgeInsets.all(minValue - 5)),
                Text(
                  "${widget.data}",
                  style: t,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Status"),
              Padding(padding: EdgeInsets.all(minValue - 5)),
              Icon(
                Icons.verified_user,
                color: greenColor,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSUbmitBtn() {
    return ListTile(
      title: Container(
        width: double.infinity,
        child: RaisedButton(
          padding: EdgeInsets.all(minValue * 2),
          onPressed: _onSubmit,
          color: Theme.of(context).accentColor,
          clipBehavior: Clip.antiAlias,
          elevation: 0.2,
          child: Text(
            "Submit",
            style: Theme.of(context).textTheme.title.apply(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildResponseNotifier() {
    return responseMessage == null || responseMessage.isEmpty
        ? Container()
        : MyMessageNotifier(
            backgroundColor: _hasError ? Colors.red : Colors.green,
            message: responseMessage,
            onClose: () {
              setState(() {
                responseMessage = '';
                _hasError = false;
              });
            },
          );
  }

  Widget _buildBody() {
    return Form(
      key: _globalKey,
      autovalidate: _autoValidate,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: minValue * 2),
            child: _buildResponseNotifier(),
          ),
          _divider(),
          _buildEmail(),
          _divider(),
          _divider(),
          MyForgotOtpScreen(
            controller: _otpController,
            hasError: _hasError,
            onComplete: (String otpCode) {
              //print("Entered OTP Code: $otpCode");
              if (otpCode.isNotEmpty) {
                setState(() {
                  isVisible = true;
                  myOtpCode = otpCode;
                });
              }
            },
            onChangeText: (String text) {
              if (text.length != 6) {
                setState(() {
                  isVisible = false;
                });
              }
            },
          ),
          isVisible
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: minValue),
                  child: Column(
                    children: <Widget>[
                      _divider(),
                      _password(),
                      _divider(),
                      _divider(),
                      _confirmPassword(),
                      _divider(),
                      _divider(),
                      isLoading ? MyComponentsLoader() : _buildSUbmitBtn()
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Reset password"),
      ),
      body: GestureDetector(
        child: _buildBody(),
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      ),
    );
  }
}
