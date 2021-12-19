import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class ApproveRejectMessageTile extends StatelessWidget {
  final ApproveRejectMessage message;

  ApproveRejectMessageTile({this.message});

  bool get _hasApproved =>
      message.negotiationAction == NegotiationAction.APPROVE;

  @override
  Widget build(BuildContext context) {
    final UserModel loggedInUser =
        Provider.of(context).dataManager.authUser.user;
    print("Approverejected User: ${message.user}");
    return Container(
      color: buySellBackground,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 30.0,
            child: _hasApproved
                ? Icon(
                    Icons.done_all,
                    color: greenColor,
                  )
                : Icon(
                    Icons.warning,
                    color: redColor,
                  ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
//          "${message.message} by ${message.user.name} ${loggedInUser.userId == message.user.userId ? ' (you)' : ''}",
                "${message.message}",
                style: TextStyle(
                    color: _hasApproved ? greenColor : redColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text("${_hasApproved ? 'ACCEPTED' : 'REJECTED'}",
                  style: TextStyle(color: Colors.white70, fontSize: 12))
            ],
          ))
        ],
      ),
    );
  }
}
