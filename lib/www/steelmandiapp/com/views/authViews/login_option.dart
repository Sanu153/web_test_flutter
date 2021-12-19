import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';

class MyLoginOption extends StatelessWidget {
  final double _minValue = 8.0;

  final bool isSelected;
  final Function onPressed;

  MyLoginOption({this.isSelected, this.onPressed});

  Widget _getDivider() {
    return SizedBox(
      height: 15,
    );
  }

  Widget _buildManualLogin(BuildContext context) {
    double btnSize = 20.0;
    double iconSize = 30.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton.icon(
          onPressed: onPressed,
          icon: Icon(isSelected ? Icons.phone_android : Icons.email),
          label: Text(
            "${isSelected ? 'Login with phone' : 'Login with email'}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
//        RawMaterialButton(
//          onPressed: onPressed,
//          child: new Icon(
//            Icons.email,
//            size: iconSize,
//            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
//          ),
//          shape: CircleBorder(),
//          elevation: 2.0,
//          fillColor:
//              isSelected ? Theme.of(context).primaryColor : Colors.white30,
//          padding: EdgeInsets.all(btnSize),
//        ),
//        SizedBox(
//          width: 15,
//        ),
//        RawMaterialButton(
//          onPressed: onPressed,
//          child: new Icon(
//            Icons.phone_iphone,
//            size: iconSize,
//            color: !isSelected ? Colors.white : Theme.of(context).primaryColor,
//          ),
//          shape: CircleBorder(),
//          elevation: 2.0,
//          fillColor:
//              !isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
//          padding: EdgeInsets.all(btnSize),
//        ),
      ],
    );
  }

  Widget _buildSocialLogin(BuildContext context) {
    double btnSize = 20.0;
    double iconSize = 20.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {
            DialogHandler.showMySuccessDialog(
                context: context,
                message: "Rehjkjdskjvjkvhkvhkvkhfvkj HDhfjcnsdkjchidhiukj",
                title: "Success");
          },
          child: new Icon(
            FontAwesomeIcons.facebookF,
            size: iconSize,
            color: Colors.white,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.indigo,
          padding: EdgeInsets.all(btnSize),
        ),
        SizedBox(
          width: 15,
        ),
        RawMaterialButton(
          onPressed: () {
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (BuildContext context) => MyprefernceScreen()));
          },
          child: new Icon(
            FontAwesomeIcons.google,
            size: iconSize,
            color: Colors.white,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.red[300],
          padding: EdgeInsets.all(btnSize),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme.title;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Text(
//            "Let's Get Started With",
//            style: t,
//          ),
          _getDivider(),
          _buildManualLogin(context),
          _getDivider(),
//          Text(
//            "Or",
//            style: TextStyle(fontSize: 18),
//          ),
//          SizedBox(
//            height: 8,
//          ),
//          Text(
//            "your social network",
//            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//          ),
//          _getDivider(),
//          _buildSocialLogin(context)
        ],
      ),
    );
  }
}
