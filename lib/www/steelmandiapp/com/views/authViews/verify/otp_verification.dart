import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/RegistrationState.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/verificationBloc/otp_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/verificationBloc/otp_state.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/message_notifier.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/my_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/restAPIs/rest_apis.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/authViews/login_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/preference_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/observer.dart';

class MyOTPVerifyScreen extends StatefulWidget {
  final String data;
  final String notifierType;
  final bool visibleNotifier;
  final String notifierMessage;

  MyOTPVerifyScreen({
    @required this.data,
    this.notifierType = 'email',
    this.visibleNotifier = false,
    this.notifierMessage = '',
  });

  @override
  _MyOTPVerifyScreenState createState() => _MyOTPVerifyScreenState();
}

class _MyOTPVerifyScreenState extends State<MyOTPVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();

  double minValue = 8.0;

  final int pinLength = 6;

  String errorMessage = '';
  bool closeNotifier = false;
  String message = '';
  bool hasError = false;
  bool isLoading = false;

  OtpBloc _otpBloc;

  @override
  void didChangeDependencies() {
    SystemConfig.makeStatusBarVisible();

    super.didChangeDependencies();
    _otpBloc = Provider.of(context).fetch(OtpBloc);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    closeNotifier = widget.visibleNotifier;
    message = widget.notifierMessage;
  }

  @override
  void dispose() {
//    _otpBloc.close();
    super.dispose();
  }

  void onVerify() async {
    String otpText = _otpController.text;
    String data = widget.data; // EMail or Phone
    if (data.isNotEmpty && otpText.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      final Map<dynamic, dynamic> _resultSet =
          await _otpBloc.onOTPVerify(email: data, otpCode: otpText);
      final ActionState state = _resultSet[ActionState];
      final AuthUser authUser = _resultSet[AuthUser];
      //print("Action State: $state");
      //print("AuthUser: $authUser");
      _otpController.text = '';
      setState(() {
        isLoading = false;
        closeNotifier = false;
        if (state == ActionState.ERROR) {
          // Handle Error
          hasError = true;
          errorMessage = "Something went wrong";
        } else if (state == ActionState.FAILED) {
          // Handle Failed
          hasError = true;
          errorMessage = authUser.responseMessage;
        } else if (state == ActionState.SUCCESS) {
          // Handle Success
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => MyprefernceScreen(
                        wilExit: false,
                      )),
              (Route<dynamic> r) => false);
        } else {
          // Handle Loader
        }
      });
    } else {
      setState(() {
        errorMessage = 'Please enter your code';
        hasError = true;
        closeNotifier = true;
      });
    }
  }

  Widget _buildSubmitBtn() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(vertical: minValue * 2),
        disabledElevation: 0.0,
        textColor: Colors.white,
        disabledColor: Colors.red[300],
        elevation: 0.0,
        onPressed: isLoading ? null : () => onVerify(),
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(minValue * 4))),
        child: isLoading
            ? MyComponentsLoader()
            : Text(
                "VERIFY",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .apply(color: Colors.white),
              ),
      ),
    );
  }

  Widget _textField() {
    return Center(
      child: PinCodeTextField(
        autofocus: false,
        controller: _otpController,
        hideCharacter: false,
        highlight: true,
        pinBoxWidth: 30.0,
        highlightColor: Colors.blue,
        defaultBorderColor: Colors.black,
        hasTextBorderColor: Theme.of(context).primaryColorDark,
        maxLength: pinLength,
//      hasError: hasError,
//      maskCharacter: "*",
//      onTextChanged: (text) {
//        hasError = true;
//        //print("TextChanged: $text");
//      },
        onDone: (text) {
          //print(text);
        },
//      pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
        wrapAlignment: WrapAlignment.spaceEvenly,
        pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
        pinTextStyle: TextStyle(fontSize: 30.0),

        pinTextAnimatedSwitcherTransition:
            ProvidedPinBoxTextAnimation.scalingTransition,
        pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
      ),
    );
  }

  Widget _resendButton(String status) {
    return FlatButton(
      onPressed: () async {
        ResponseFlags flag = await _otpBloc.onResendOTP(email: widget.data);
        if (flag != null) {
          setState(() {
            closeNotifier = false;
            hasError = flag.responseStatus == SUCCESS_STATUS ? false : true;
            errorMessage = message = flag.responseMessage;
          });
        }
      },
      child: Text("${status.isEmpty ? 'Resend' : 'Retry'}"),
      textColor: Theme.of(context).accentColor,
    );
  }

  Widget _resendOtp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("If you didn't receive a code?"),
//        _resendButton('')
        Observer<List<Object>>(
          stream: _otpBloc.resendOtp$,
          onWaiting: (context) {
            return _resendButton('');
          },
          onSuccess: (context, List datSet) {
            OtpState state = datSet[0];
            ResponseFlags flag = datSet[1];
            //print(state);
            if (state == OtpState.LOADING) {
              return MyComponentsLoader();
            } else {
              return _resendButton('');
            }
          },
        )
      ],
    );
  }

  Widget _buildOTPForm() {
    return Container(
      padding: EdgeInsets.only(top: minValue * 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(minValue * 4),
            topRight: Radius.circular(minValue * 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: minValue * 2),
            child: Text(
              "Enter your OTP",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          getSizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: minValue * 2),
            child: _buildOtpMsg(),
          ),
          getSizedBox(),
          _textField(),
          getSizedBox(),
          _resendOtp(),
//          _onError(),
          getSizedBox(),
          _buildSubmitBtn(),
        ],
      ),
    );
  }

  Widget _buildOtpMsg() {
    return Container(
      child: Text(
        "We have sent the OTP to ${widget.data}",
//        "${widget.notifierMessage}",
        style: TextStyle(
            fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildNotifier() {
    return closeNotifier
        ? Container()
        : MyMessageNotifier(
            backgroundColor: hasError ? redColor : greenColor,
            onClose: () {
//              _otpBloc.closeDialog();
              setState(() {
                closeNotifier = true;
                hasError = false;
              });
            },
            message: "${hasError ? errorMessage : message}",
          );
  }

  Widget _buildHeaderStatus() {
    final t = Theme.of(context).textTheme.title;
    final edit = Theme.of(context)
        .textTheme
        .body2
        .apply(color: Theme.of(context).backgroundColor);

    return Container(
      padding: EdgeInsets.all(minValue * 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(minValue * 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("My ${widget.notifierType}"),
                Padding(padding: EdgeInsets.all(minValue - 5)),
                Text(
                  "${widget.data}",
                  style: t,
                ),
                getSizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Status: "),
                    Text(
                      "NOT VERIFIED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: redColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),

//                Icon(
//                  Icons.verified_user,
//                  color: redColor,
//                )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSizedBox() {
    return SizedBox(
      height: minValue * 2,
    );
  }

  Widget _buildBody({String status, AuthUser data}) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: minValue * 2, vertical: minValue),
      child: ListView(
        children: <Widget>[
          _buildNotifier(),
          getSizedBox(),
          _buildHeaderStatus(),
          getSizedBox(),
//          _buildOtpMsg(),
          getSizedBox(),
          getSizedBox(),
          _buildOTPForm()
        ],
      ),
    );
  }

  Widget _buildScaffold() {}

  Future<bool> _onBack() async {
    print("Back");
    await DialogHandler.openAlertDialog(
        context: context,
        title: "Exit",
        widget: Text("Are you sure, you want to do this?"),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("CLOSE"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => MyloginScreen()));
            },
            child: Text("OKAY"),
          ),
        ]);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onBack(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Verify account"),
          elevation: 0.0,
        ),
        backgroundColor: Colors.grey[200],
        body: GestureDetector(
          child: _buildBody(),
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        ),
      ),
    );
    return Observer<List<Object>>(
//      stream: _otpBloc.otpVerify$,
      onWaiting: (context) {
//        return _buildScaffold(status: 'waiting');
      },
      onSuccess: (context, List dataSet) {
        final RegistrationState state = dataSet[0];
        final AuthUser _authUser = dataSet[1];
        if (state == null && _authUser == null) {
          //print("Error Occered");
//          return _buildScaffold(status: 'error');
        } else if (state.authenticated ==
            RegistrationState.initial().authenticated) {
          closeNotifier = false;
          hasError = false;
          errorMessage = null;
          return _buildScaffold();
        } else if (state.authenticated ==
            RegistrationState.loading().authenticated) {
          return MyLoaderScreen();
        } else if (state.authenticated ==
            RegistrationState.failed().authenticated) {
          // Failed
          closeNotifier = true;
          hasError = true;
          errorMessage = _authUser.responseMessage;
          _otpController.text = '';
//          return _buildScaffold(status: 'failed', data: _authUser);
        } else {
          // Navigate

          return MyprefernceScreen(
            wilExit: false,
          );
        }
      },
    );
  }
}
