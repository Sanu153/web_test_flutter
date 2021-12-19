import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class MyForgotOtpScreen extends StatelessWidget {
  final Function onComplete;
  final Function onChangeText;
  final bool hasError;
  final TextEditingController controller;

  MyForgotOtpScreen({@required this.onComplete,
    this.onChangeText,
    this.hasError = false,
    @required this.controller});

  int pinLength = 6;
  double minValue = 8.0;

  Widget _textField(BuildContext context) {
    return PinCodeTextField(
      autofocus: true,
      hideCharacter: false,
//      controller: controller,
      highlight: true,
      pinBoxWidth: 30.0,
      highlightColor: Colors.blue,
      defaultBorderColor: Colors.black,
      hasTextBorderColor: Theme.of(context).primaryColorDark,
      maxLength: pinLength,
      hasError: hasError,
//      maskCharacter: "*",
      onTextChanged: (text) {
        onChangeText(text);
      },
      onDone: (text) {
        onComplete(text);
        //print("OTP FROM FIELD: $text");
      },
//      pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
      wrapAlignment: WrapAlignment.spaceEvenly,
      pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
      pinTextStyle: TextStyle(fontSize: 30.0),

      pinTextAnimatedSwitcherTransition:
          ProvidedPinBoxTextAnimation.scalingTransition,
      pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: minValue, horizontal: minValue * 2),
      padding: EdgeInsets.symmetric(
          vertical: minValue * 2, horizontal: minValue * 2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(minValue * 3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Enter your OTP",
            style: Theme.of(context).textTheme.title,
          ),
          _textField(context)
        ],
      ),
    );
  }
}
