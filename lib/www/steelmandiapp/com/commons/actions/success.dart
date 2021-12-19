import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MySuccessViews extends StatelessWidget {
  final String message;

  const MySuccessViews({@required this.message});

  Widget _buildSuccess(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 35.0,
            backgroundColor: greenColor,
            child: SpinKitDoubleBounce(
              size: 30.0,
              itemBuilder: (BuildContext context, int index) {
                return Icon(
                  Icons.done,
                  size: 34,
                  color: Colors.white,
                );
              },
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "$message",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subhead
                .apply(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuccess(context);
  }
}
