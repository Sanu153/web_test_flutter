import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/validation/auth_validation.dart';

class PasswordChangeViews extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  PasswordChangeViews({@required this.authenticationBloc});

  @override
  _PasswordChangeViewsState createState() => _PasswordChangeViewsState();
}

class _PasswordChangeViewsState extends State<PasswordChangeViews>
    with AuthValidation {
  TextEditingController _oldPasswordController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPaswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final double minValue = 8.0;
  bool obscureText = true;

  String _errorText;
  String _confirmErrorText;
  bool isLoading = false;
  bool inValid = false;

  final Map<String, dynamic> _dataSet = {};

  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  void _reset() {
    _oldPasswordController.text = '';
    _passwordController.text = '';
    _confirmPaswordController.text = '';
  }

  void _onSave() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      final Map<String, dynamic> _dataSet = {};
      _dataSet['old_password'] = _oldPasswordController.text;
      _dataSet['new_password'] = _passwordController.text;

      //print("User PasswordSet: $_dataSet");

      final ResponseResult _result =
      await widget.authenticationBloc.updateUserPassword(_dataSet);

      setState(() {
        isLoading = false;
      });

      if (_result.data is Failure) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            '${_result.data.responseMessage}',
            style: TextStyle(color: redColor),
          ),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
        ));
        _reset();
        return;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Updated successfully',
          style: TextStyle(color: greenColor),
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ));
      _reset();
    }
  }

  void _onChangedPassword(String value) {
    String validate = validatePassword(value);
    setState(() {
      _errorText = validate;
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

  String makeConfirmPassword(String confrim) {
    String password = _passwordController.text;
    if (confrim.isEmpty) {
      return 'Please enter confirm password';
    } else if (password != confrim) {
      return 'Passwords not match';
    }
  }

  Widget _buildOldPassword() {
    return TextFormField(
      controller: _oldPasswordController,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: InputBorder.none,
          hintText: 'Old Password',
          labelText: 'Old Password',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildNewPassword() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      validator: validatePassword,
      onChanged: _onChangedPassword,
      decoration: InputDecoration(
          errorText: _errorText,
          hintText: 'New Password',
          suffixIcon: GestureDetector(
              child: Text(
                obscureText ? 'SHOW' : 'HIDE',
                style: TextStyle(fontSize: 12.0, color: Colors.black87),
              ),
              onTap: () {
                setState(() {
                  obscureText = obscureText ? false : true;
                });
              }),
          labelText: 'New Password',
          border: InputBorder.none,
          errorStyle: _errorStyle,
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      controller: _confirmPaswordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      validator: makeConfirmPassword,
      onChanged: _onChangedConfirmPassword,
      decoration: InputDecoration(
          hintText: 'Confirm New Password',
          border: InputBorder.none,
          errorText: _confirmErrorText,
          labelText: 'Confirm New Password',
          errorStyle: _errorStyle,
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildTextBackground(Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: minValue),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(minValue)),
      child: child,
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      child: RaisedButton(
        onPressed: () => _onSave(),
        padding: EdgeInsets.symmetric(vertical: minValue * 2),
        elevation: 0.0,
        color: Theme
            .of(context)
            .primaryColor,
        textColor: Colors.white,
        child: Text('SAVE'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: minValue * 4, right: 100.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: minValue * 2),
              child: Text(
                "Update password",
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            ),
            _buildTextBackground(_buildOldPassword()),
            SizedBox(
              height: minValue * 2,
            ),
            _buildTextBackground(_buildNewPassword()),
            SizedBox(
              height: minValue * 2,
            ),
            _buildTextBackground(_buildConfirmPassword()),
            SizedBox(
              height: minValue * 2,
            ),
            isLoading ? MyComponentsLoader() : _buildSubmitBtn(),
            SizedBox(
              height: minValue * 4,
            ),
          ],
        ),
      ),
    );
  }
}
