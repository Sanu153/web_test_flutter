import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/signin_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/message_notifier.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/resetViews/reset_password_screens.dart';

class MyEmailVerificationScreen extends StatefulWidget {
  @override
  _MyEmailVerificationScreenState createState() =>
      _MyEmailVerificationScreenState();
}

class _MyEmailVerificationScreenState extends State<MyEmailVerificationScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  String responseMessage = '';
  SIgnInBloc _sIgnInBloc;

  bool hasError = false;
  bool isLoading = false;
  ResponseFlags _flags;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _sIgnInBloc = Provider.of(context).fetch(SIgnInBloc);

    SystemConfig.makeStatusBarVisible();
  }

  @override
  void dispose() {
    //print("Email Disposed Called");
    _sIgnInBloc.closeEmailStream();
    super.dispose();
  }

  void onResetSubmit() async {
    if (_globalKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      final ResponseFlags flags =
          await _sIgnInBloc.onVerifyEmail(email: _emailController.text);
      //print('FLags: ${flags.responseMessage} ${flags.responseStatus}');

      if (flags.responseStatus == SUCCESS_STATUS) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyResetPasswordScreen(
                      data: _emailController.text,
                      dataType: "email",
                    )));
      } else {
        //print("On Failed");
        _onError(flags);
      }
    }
  }

  void _onError(ResponseFlags flags) {
    setState(() {
      isLoading = false;
      hasError = true;
      responseMessage = flags.responseMessage;
      _emailController.text = '';
    });
  }

  void _showModal() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        context: context,
        builder: (builder) {
          return Container(
            child: Text('Hello From Modal Bottom Sheet'),
            padding: EdgeInsets.all(40.0),
          );
        });
  }

  String _emailValidator(String value) {
    bool isEmail = EmailValidator.validate(value);
    if (value.isEmpty) {
      return 'Email can not be empty';
    } else if (!isEmail) {
      return 'Email must be valid';
    }
  }

  Widget _buildForgotSubmitBtn() {
    final t = Theme.of(context).textTheme.title;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(vertical: 12),
        onPressed: onResetSubmit,
        child: Text(
          "Sumbit",
          style: t.apply(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // When a user coming from Forgot Password Screen
  Widget _buildBody() {
    final t = Theme.of(context).textTheme.title;
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text("Reset password"),
          ),
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Form(
              key: _globalKey,
              autovalidate: true,
              child: ListView(
//      shrinkWrap: true,
                children: <Widget>[
                  responseMessage == null || responseMessage.isEmpty
                      ? Container()
                      : MyMessageNotifier(
                          backgroundColor: hasError ? Colors.red : Colors.green,
                          message: _flags.responseMessage,
                          onClose: () {},
                        ),
                  ListTile(
                    title: Text(
                      "Enter email",
                      style: t,
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text("Verify your email for reseting password"),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      validator: _emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: "Enter email",
                        labelStyle: Theme
                            .of(context)
                            .textTheme
                            .subhead,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading ? _buildLoader() : _buildForgotSubmitBtn()
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
