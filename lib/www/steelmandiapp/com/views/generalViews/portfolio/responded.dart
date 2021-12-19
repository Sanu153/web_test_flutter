import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/open_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/negotiation_chat.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/contract/closed_contract_screen.dart';

class Responded extends StatelessWidget {
  final OpenNegotiation openNegotiation;
  final bool hasChatWindow;
  final String requestUserType;

  Responded(
      {@required this.openNegotiation,
      this.hasChatWindow = true,
      this.requestUserType});

  final double minValue = 8.0;

  bool isMeLastResponder(BuildContext context) {
    final DataManager manager = Provider.of(context).dataManager;
    final UserModel currentLoginUser = manager.authUser.user;
    if (openNegotiation.user != null) {
      return openNegotiation
              .respondersAndNegotiations[0].lastNegotiation.proposerId ==
          currentLoginUser.userId;
    } else {
      return false;
    }
  }

  void onRespondersTap(BuildContext context) {
    final PortfolioBloc portfolioBloc =
        Provider.of(context).fetch(PortfolioBloc);
    // Update Remaining Quantity
    portfolioBloc.updateQuantityRemaining(openNegotiation.quantityRemaining);

    if (hasChatWindow) {
      DialogHandler.openPortfolioDialog(
          context: context,
          child: MyNegotiationChat(
            lastNegotiation:
                openNegotiation.respondersAndNegotiations[0].lastNegotiation,
            // First Index is Last Negotiation
            requestUserType: requestUserType,
            responder: openNegotiation.user,
            // This Is The Requested User Who has Created The Request
            portfolioBloc: portfolioBloc,
            tradeUnit: openNegotiation.tradeUnit.shortName,
          ));
    } else {
      DialogHandler.openPortfolioDialog(
          context: context,
          child: ClosedContractScreen(
              lastNegotiation:
                  openNegotiation.respondersAndNegotiations[0].lastNegotiation,
              requestUserType: requestUserType,
              responder: openNegotiation.user,
              buySell: openNegotiation.buySell,
              portfolioBloc: portfolioBloc,
              tradeUnit: openNegotiation.tradeUnit.shortName,
              orderDetail:
                  openNegotiation.respondersAndNegotiations[0].orderDetail));
    }
  }

  String getDateTime(String date) =>
      DateFormat("dd MMM yy, HH:mm").format(DateTime.parse(date));

  Widget _buildListTile(BuildContext context) {
    if (openNegotiation.respondersAndNegotiations.length == 0)
      return Text(
        "Unable to get data",
        style: TextStyle(color: Colors.orange[800]),
      );
    final Negotiation lastNegotiation =
        openNegotiation.respondersAndNegotiations[0].lastNegotiation;

    final title =
        Theme.of(context).textTheme.subtitle.apply(color: Colors.white);
    final sub = TextStyle(fontSize: 11.0, color: Colors.white70);
    return InkWell(
      onTap: () => onRespondersTap(context),
      child: Container(
        height: 90,
        padding: EdgeInsets.all(minValue),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: greenColor,
              radius: 12.0,
              backgroundImage: openNegotiation.user.imageUrl == null
                  ? AssetImage('assets/image/default_user.png')
                  : NetworkImage(openNegotiation.user.imageUrl),
            ),
            SizedBox(
              width: minValue,
            ),
            Container(
              width: 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "${openNegotiation.user.name}",
                      style: title,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Payment: ${lastNegotiation.paymentsInDays}",
                    style: sub,
                  ),
                  Text(
                    "Delivery: ${lastNegotiation.deliveryInDays}",
                    style: sub,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${getDateTime(lastNegotiation.createdAt)}",
                    style: TextStyle(color: Colors.red[200], fontSize: 10.0),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "${lastNegotiation.quantity} ${openNegotiation.tradeUnit.shortName}",
                        style: sub,
                      ),
                      Text(
                        "₹ ${lastNegotiation.pricePerUnit}",
                        style: sub,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      // true => Do not show while an user checking from opened list
                      hasChatWindow
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // OrderDetail == null > No Status, Neither Accept or reject
                                openNegotiation.respondersAndNegotiations[0]
                                            .orderDetail ==
                                        null
                                    ? Container()
                                    : Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: openNegotiation
                                                        .respondersAndNegotiations[
                                                            0]
                                                        .orderDetail
                                                        .status ==
                                                    "Accepted"
                                                ? greenColor
                                                : redColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          "${openNegotiation.respondersAndNegotiations[0].orderDetail.status}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0),
                                        ),
                                      ),
                              ],
                            ),
                    ],
                  ),
                  SizedBox(
                    width: minValue,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white54,
                        size: 18,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: minValue * 2),
      color: buySellBackground,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: minValue * 3, top: minValue),
            child: Row(
              children: <Widget>[
                Text(
                  "Responded To:  ",
                  style: TextStyle(color: greenColor),
                ),
                Icon(
                  Icons.redo,
                  color: greenColor,
                  size: 18,
                ),
              ],
            ),
          ),
          _buildListTile(context),
        ],
      ),
    );
  }
}
