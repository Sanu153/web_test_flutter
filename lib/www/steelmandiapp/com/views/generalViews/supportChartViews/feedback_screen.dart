import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/support_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/message_notifier.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/validation/auth_validation.dart';

class FeedbackFormScreen extends StatefulWidget {
  @override
  _FeedbackFormScreenState createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen>
    with AuthValidation {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

//  final TextEditingController _firstNameController = TextEditingController();
//  final TextEditingController _lastNameController = TextEditingController();

  final double _minValue = 8.0;
  bool isLoading = false;
  bool hasError = false;
  String message = "";
  bool isVisible = false;

  String _feedbackType = 'COMMENT';

  File _image;
  final ImagePicker picker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 14,
  );

  UserModel user;
  SupportBloc _supportBloc;

  void _updateUI() async {
//    _firstNameController.text = user.firstName ?? '';
//    _lastNameController.text = user.lastName ?? '';
//
//    _emailController.text = user.email;
  }

  @override
  void didChangeDependencies() {
    SystemConfig.makeDevicePotrait();
    _supportBloc = Provider.of(context).fetch(SupportBloc);
    user = Provider.of(context).dataManager.authUser.user;
    _updateUI();
//    _handleRotation();

    super.didChangeDependencies();
  }

  void _onSave() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
        message = "";
        hasError = false;
        isVisible = false;
      });
      final dataSet = {
        "title": _titleController.text,
        "description": _messageController.text
      };
      ResponseResult _result = await _supportBloc.onFeedbackSubmit(dataSet);
      if (_result.data is Failure) {
        // Failed
        final Failure _failed = _result.data;
        setState(() {
          isVisible = true;
          isLoading = false;
          hasError = true;
          message = _failed.responseMessage;
        });
        return;
      }
      ResponseFlags _flag = _result.data;
      setState(() {
        isVisible = true;
        hasError = false;
        message = _flag.responseMessage;
        isLoading = false;
      });
      _titleController.text = "";
      _messageController.text = "";
    }
  }

  void _getImage(bool hasCamera) async {
    try {
      final pickedFile = await picker.getImage(
          source: hasCamera ? ImageSource.camera : ImageSource.gallery);

      Navigator.of(context).pop();
      if (pickedFile == null) return;
      setState(() {
        _image = File(pickedFile.path);
      });
      // Api
      if (_image == null) return;
    } catch (e) {
      //print("Error In Selecting Image: ${e.toString()}");
    }
  }

  void onImageFieldTap() async {
//    DialogHandler.openAlertDialog(
//        context: context,
//        title: 'Choose Image',
//        widget: _buildOptionList(),
//        isBarrier: false);
  }

  void _handleRotation() async {
    SystemConfig.makeStatusBarVisible();
    await SystemConfig.makeDevicePotrait();
  }

  @override
  void didUpdateWidget(FeedbackFormScreen oldWidget) {
    _handleRotation();
    super.didUpdateWidget(oldWidget);
  }

  Future<bool> _onBackTap() async {
    SystemConfig.makeStatusBarHide();
    await SystemConfig.makeDeviceLandscape()
        .then((value) => Navigator.of(context).pop());
    return true;
  }

  Widget _buildTitle() {
    return TextFormField(
      controller: _titleController,
      validator: usernameValidator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: _minValue, horizontal: _minValue),
          labelText: 'Title',
          hintText: 'Enter title',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildLastName() {
    return TextFormField(
//      controller: _lastNameController,
      validator: usernameValidator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: _minValue, horizontal: _minValue),
          hintText: 'Last Name',
          labelText: 'Last Name',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
//      controller: _emailController,
      keyboardType: TextInputType.text,
      validator: validateEmail,
      onChanged: (String value) {},
      readOnly: true,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: _minValue, horizontal: _minValue),
          suffixIcon: Icon(
            Icons.do_not_disturb_alt,
            color: redColor,
          ),
          labelText: 'Email',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      controller: _messageController,
      keyboardType: TextInputType.text,
      maxLines: 4,
      decoration: InputDecoration(
          errorStyle: _errorStyle,
          hintText: 'Message',
          labelText: 'Description',
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: _minValue, horizontal: _minValue),
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Image"),
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () => onImageFieldTap(),
          child: Container(
            height: 80.0,
            child:
                _image == null ? Text('Choose an image') : Image.file(_image),
          ),
        )
      ],
    );
  }

  Widget _buildFeedbackType() {
    return Row(
      children: <Widget>[
        Radio<String>(
            value: 'COMMENT',
            groupValue: _feedbackType,
            onChanged: (String v) {
              setState(() {
                _feedbackType = v;
              });
            }),
        Text('Comments'),
        SizedBox(
          width: _minValue,
        ),
        Radio<String>(
            value: 'BUG',
            groupValue: _feedbackType,
            onChanged: (String v) {
              setState(() {
                _feedbackType = v;
              });
            }),
        Text('Bug Reports'),
        SizedBox(
          width: _minValue,
        ),
        Radio<String>(
            value: 'QUESTION',
            groupValue: _feedbackType,
            onChanged: (String v) {
              setState(() {
                _feedbackType = v;
              });
            }),
        Text('Questiions')
      ],
    );
  }

//  Widget _buildOptionList() {
//    return Container(
//      height: 150,
//      child: Column(
//        children: <Widget>[
//          ListTile(
//            leading: Icon(Icons.camera),
//            title: Text("Camera"),
//            onTap: () => _getImage(true),
//          ),
//          ListTile(
//            leading: Icon(Icons.toys),
//            title: Text("Gallery"),
//            onTap: () => _getImage(false),
//          )
//        ],
//      ),
//    );
//  }

  Widget _buildSubmitBtn() {
    return Center(
      child: Container(
        child: RaisedButton(
          onPressed: () => _onSave(),
          padding: EdgeInsets.symmetric(vertical: _minValue * 2),
          elevation: 0.0,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text('POST'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    _handleRotation();

    return WillPopScope(
      onWillPop: _onBackTap,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Feedback"),
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            !isVisible
                ? Container()
                : MyMessageNotifier(
                    backgroundColor: hasError ? redColor : greenColor,
                    onClose: () {
//              _otpBloc.closeDialog();
                      setState(() {
                        isVisible = false;
                        hasError = false;
                      });
                    },
                    message: "$message",
                  ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: _minValue * 2, vertical: _minValue * 2),
              child: Text(
                "We would love to hear your thoughts, concerns and problems with anything, so we can improve.",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.all(_minValue * 2),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                      Text("Feedback Type"),
//                      _buildFeedbackType(),
                      SizedBox(
                        height: _minValue * 2,
                      ),
                      _buildTitle(),
                      SizedBox(
                        height: _minValue * 2,
                      ),

                      _buildDescription(),
                      SizedBox(
                        height: _minValue * 2,
                      ),
//                      _feedbackType == 'BUG' ? _buildImage() : Container(),
                      SizedBox(
                        height: _minValue * 4,
                      ),
                      isLoading ? MyComponentsLoader() : _buildSubmitBtn()
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
