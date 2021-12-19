import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/validation/auth_validation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';

class UserInfo extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  UserInfo({@required this.authenticationBloc});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> with AuthValidation {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _tinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _citizenshipController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final double minValue = 8.0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Data
  String _genderValue = '';

  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  bool isValueChanged = false;
  bool isLoading = false;
  bool isImageLoading = false;

  bool newUser = false;

  final _countryList = <String>['India', 'Australia', 'Nepal', 'China'];

  Future<ResponseResult> _futureResponseResult;
  ResponseResult _responseResult;

  File _image;
  final picker = ImagePicker();

  void _onCreated() async {
    _futureResponseResult = widget.authenticationBloc.getUserProfile();
    _responseResult = await _futureResponseResult;

    if (_responseResult.data is Success) {
      final UserModel userData = _responseResult.data.data;

      _updateUI(userData);
    }
  }

  void _updateUI(UserModel userModel) {
    _image = null;
    // Update Controller
    _firstNameController.text = userModel.firstName;
    _lastNameController.text = userModel.lastName;
    _tinController.text = userModel.tin;
    _emailController.text =
        widget.authenticationBloc.dataManager.authUser.user.email;
    _phoneController.text = userModel.mobileNo;
    _dobController.text = userModel.dob;
    _citizenshipController.text = userModel.citizenship;
    _addressController.text = userModel.address;
    _zipController.text = userModel.pin;
    _cityController.text = userModel.city;
    _countryController.text = userModel.country;
    _stateController.text = userModel.state;
    // Update Others
    _genderValue = userModel.gender;

    print("New User: ${userModel.newUser}");
    newUser = userModel.newUser;
  }

  @override
  initState() {
    _onCreated();

    super.initState();
  }

  void _getImage(bool hasCamera) async {
    try {
      final pickedFile = await picker.getImage(
          source: hasCamera ? ImageSource.camera : ImageSource.gallery);

      Navigator.of(context).pop();
      if (pickedFile == null) return;
      setState(() {
        _image = File(pickedFile.path);
        isImageLoading = true;
      });
      // Api
      if (_image == null) return;
      ResponseResult _result =
          await widget.authenticationBloc.updateUserProfileAvatar(_image);
      setState(() {
        isImageLoading = false;
      });
      if (_result.data is Failure) {
        //print('Failed to Update: ${_result.data.responseMessage}');
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            '${_result.data.responseMessage}',
            style: TextStyle(color: redColor),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ));
        return;
      }

      //print("Image Updated");
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Updated successfully',
          style: TextStyle(color: greenColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } catch (e) {
      //print("Error In Selecting Image: ${e.toString()}");
    }
  }

  void _chooseOption() {
    DialogHandler.openAlertDialog(
        context: context,
        title: 'Choose Image',
        widget: _buildOptionList(),
        isBarrier: false);
  }

  void _onSave() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      final Map<String, dynamic> _dataSet = {};
      _dataSet['first_name'] = _firstNameController.text;
      _dataSet['last_name'] = _lastNameController.text;
      _dataSet['mobile'] = _phoneController.text;
      _dataSet['gender'] = _genderValue;
      _dataSet['dob'] = _dobController.text;
      _dataSet['citizenship'] = _citizenshipController.text;
      _dataSet['city'] = _cityController.text;
      _dataSet['state'] = _stateController.text;
      _dataSet['country'] = _countryController.text;
      _dataSet['pin'] = _zipController.text;
      _dataSet['address'] = _addressController.text;
      _dataSet['tin'] = _tinController.text;
      _dataSet['new_user'] = newUser;

      //print("User Data Set: $_dataSet");

      final ResponseResult _result =
          await widget.authenticationBloc.updateUserProfile(_dataSet);

      setState(() {
        isLoading = false;
      });

      if (_result.data is Failure) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            '${_result.data.responseMessage}',
            style: TextStyle(color: redColor),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ));
        return;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Updated successfully',
          style: TextStyle(color: greenColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    }
  }

  Widget _buildOptionList() {
    return Container(
      height: 150,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera),
            title: Text("Camera"),
            onTap: () => _getImage(true),
          ),
          ListTile(
            leading: Icon(Icons.toys),
            title: Text("Gallery"),
            onTap: () => _getImage(false),
          )
        ],
      ),
    );
  }

  Widget _buildFirstName() {
    return TextFormField(
      controller: _firstNameController,
      validator: usernameValidator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: InputBorder.none,
          labelText: 'First Name',
          hintText: 'First Name',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      controller: _lastNameController,
      validator: usernameValidator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: InputBorder.none,
          hintText: 'Last Name',
          labelText: 'Last Name',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.text,
      validator: validateEmail,
      onChanged: (String value) {},
      readOnly: true,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: InputBorder.none,
          suffixIcon: Icon(
            Icons.do_not_disturb_alt,
            color: redColor,
          ),
          labelText: 'Email',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildMobile() {
    return TextFormField(
      controller: _phoneController,
      validator: mobileValidator,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: InputBorder.none,
          errorStyle: _errorStyle,
          labelText: 'Mobile No',
          hintText: 'Mobile Number',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildTin() {
    return TextFormField(
      controller: _tinController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: minValue),
          border: InputBorder.none,
          errorStyle: _errorStyle,
          hintText: 'Taxpayer Identification Number',
          labelText: 'TIN',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildCountry() {
    return TextFormField(
      controller: _countryController,
//      validator: usernameValidator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: InputBorder.none,
          labelText: 'Country',
          hintText: 'Country Name',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(border: InputBorder.none),
      onChanged: (String value) {
        //print('Selected Country: $value');
      },
      hint: Text('Country'),
      items: _countryList
          .map((country) => DropdownMenuItem<String>(
                child: Text('$country'),
                value: country,
              ))
          .toList(),
    );
  }

  Widget _buildState() {
    return TextFormField(
      controller: _stateController,
//      validator: usernameValidator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: InputBorder.none,
          labelText: 'State',
          hintText: 'State Name',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildGender() {
    return Row(
      children: <Widget>[
        Radio<String>(
            value: 'MALE',
            groupValue: _genderValue,
            onChanged: (String v) {
              setState(() {
                _genderValue = v;
              });
            }),
        Text('Male'),
        SizedBox(
          width: minValue * 2,
        ),
        Radio<String>(
            value: 'FEMALE',
            groupValue: _genderValue,
            onChanged: (String v) {
              setState(() {
                _genderValue = v;
              });
            }),
        Text('Female')
      ],
    );
  }

  Widget _buildDob() {
    return TextFormField(
      controller: _dobController,
//      validator: dobValidator,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: minValue),
          errorStyle: _errorStyle,
          border: InputBorder.none,
          hintText: 'Eg: 25-08-1990',
          labelText: 'Date Of Birth',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildCitizenShip() {
    return TextFormField(
      controller: _citizenshipController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: minValue),
          errorStyle: _errorStyle,
          hintText: 'Citizenship',
          border: InputBorder.none,
          labelText: 'Citizenship',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildCity() {
    return TextFormField(
      controller: _cityController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: minValue),
          errorStyle: _errorStyle,
          hintText: 'City',
          border: InputBorder.none,
          labelText: 'City',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildZip() {
    return TextFormField(
      controller: _zipController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: minValue),
          errorStyle: _errorStyle,
          hintText: 'ZIP code',
          border: InputBorder.none,
          labelText: 'ZIP',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildAddress() {
    return TextFormField(
      controller: _addressController,
      keyboardType: TextInputType.text,
      maxLines: 4,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: minValue),
          errorStyle: _errorStyle,
          hintText: 'Address',
          labelText: 'Address',
          border: InputBorder.none,
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildProfilePic() {
    final AuthUser _authUser = Provider.of(context).dataManager.authUser;

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
//            Padding(
//              padding: EdgeInsets.symmetric(vertical: minValue * 2),
//              child: Text(
//                "Update profile picture",
//                style: TextStyle(fontSize: 18.0, color: Colors.black87),
//              ),
//            ),
            Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: _image != null
                      ? FileImage(_image)
                      : _authUser.user.imageUrl != null
                          ? NetworkImage(_authUser.user.imageUrl)
                          : AssetImage("assets/image/default_user.png"),
                )),
            SizedBox(
              height: minValue,
            ),
            isImageLoading
                ? MyComponentsLoader()
                : RaisedButton.icon(
                    elevation: 0.0,
                    onPressed: () => _chooseOption(),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    icon: Icon(Icons.edit),
                    label: Text('Change Picture'),
                    padding: EdgeInsets.all(minValue),
                  )
          ],
        ),
      ),
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

  Widget _buildFailure(Failure failure) {
    return Container(
      child: ResponseFailure(
        title: failure.responseStatus,
        subtitle: failure.responseMessage,
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      child: RaisedButton(
        onPressed: () => _onSave(),
        padding: EdgeInsets.symmetric(vertical: minValue * 2),
        elevation: 0.0,
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: Text('SAVE'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureObserver(
        future: _futureResponseResult,
        onWaiting: (context) => MyComponentsLoader(),
        onError: (context, Failure failed) => _buildFailure(failed),
        onSuccess: (context, UserModel userModel) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: minValue * 3),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: minValue * 10),
                    child: Form(
                      key: _formKey,
                      onWillPop: () async => true,
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: minValue * 2),
                            child: Text(
                              "Update profile info",
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black87),
                            ),
                          ),
                          MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? _buildProfilePic()
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child:
                                      _buildTextBackground(_buildFirstName())),
                              SizedBox(
                                width: minValue,
                              ),
                              Expanded(
                                  child:
                                      _buildTextBackground(_buildLastName())),
                            ],
                          ),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildTin()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildEmail()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildMobile()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildGender()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildDob()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildCountry()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildState()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildCity()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildCitizenShip()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildZip()),
                          SizedBox(
                            height: minValue * 2,
                          ),
                          _buildTextBackground(_buildAddress()),
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
                  ),
                ),
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? _buildProfilePic()
                    : Container(),
              ],
            ),
          );
        });
  }
}
