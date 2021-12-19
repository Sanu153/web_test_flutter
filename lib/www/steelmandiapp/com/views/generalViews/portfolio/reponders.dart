import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/open_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/responder_negotistion.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/negotiation_chat.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/contract/closed_contract_screen.dart';

/// Users have responded To The Request
class Responders extends StatelessWidget {
  final OpenNegotiation openNegotiation;
  final bool hasChatWindow;

  /// Either Buyer or Seller
  final String requestUserType;

  Responders(
      {@required this.openNegotiation,
      this.hasChatWindow,
      this.requestUserType});

  bool isMeLastResponder(BuildContext context) {
    final DataManager manager = Provider.of(context).dataManager;
    final UserModel currentLoginUser = manager.authUser.user;
    if (openNegotiation.respondersAndNegotiations.length != 0) {
      return openNegotiation
              .respondersAndNegotiations[0].lastNegotiation.proposerId ==
          currentLoginUser.userId;
    } else {
      return false;
    }
  }

  void onRespondersTap(BuildContext context, RespondersAndNegotiations item) {
    final PortfolioBloc portfolioBloc =
        Provider.of(context).fetch(PortfolioBloc);
    // Update Remaining Quantity
    portfolioBloc.updateQuantityRemaining(openNegotiation.quantityRemaining);

    if (hasChatWindow) {
      DialogHandler.openPortfolioDialog(
          context: context,
          child: MyNegotiationChat(
            lastNegotiation: item.lastNegotiation,
            requestUserType: requestUserType,
            responder: item.responder,
            portfolioBloc: portfolioBloc,
            tradeUnit: openNegotiation.tradeUnit.shortName,
          ));
    } else {
      DialogHandler.openPortfolioDialog(
          context: context,
          child: ClosedContractScreen(
              lastNegotiation: item.lastNegotiation,
              requestUserType: requestUserType,
              buySell: openNegotiation.buySell,
              responder: item.responder,
              // This The Last Responded User.
              portfolioBloc: portfolioBloc,
              tradeUnit: openNegotiation.tradeUnit.shortName,
              orderDetail: item.orderDetail));
    }
  }

  final double minValue = 8.0;

  String getDateTime(String date) =>
      DateFormat("dd MMM yy, HH:mm").format(DateTime.parse(date));

  Widget _buildListTile(BuildContext context, RespondersAndNegotiations item) {
    final title = Theme.of(context).textTheme.body1.apply(color: Colors.white);
    final sub = TextStyle(fontSize: 11.0, color: Colors.white70);
    final DataManager manager = Provider.of(context).dataManager;

    return InkWell(
      onTap: () => onRespondersTap(context, item),
      child: Container(
        height: 92,
        padding: EdgeInsets.all(minValue),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: greenColor,
              radius: 12.0,
              backgroundImage: item.responder.imageUrl == null
                  ? AssetImage('assets/image/default_user.png')
                  : NetworkImage(item.responder.imageUrl),
            ),
            SizedBox(
              width: minValue,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "${item.responder.name}",
                      style: title,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Payment: ${item.lastNegotiation.paymentsInDays} d",
                              style: sub,
                            ),
                            SizedBox(
                              height: 2,
                            ),
//
                            Text(
                              "Delivery: ${item.lastNegotiation.deliveryInDays} d",
                              style: sub,
                            ),
                          ],
                        ),
                        isMeLastResponder(context)
                            ? Icon(
                                Icons.done_all,
                                size: 15.0,
                                color: Colors.blueAccent,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "${getDateTime(item.lastNegotiation.createdAt)}",
                    style: TextStyle(color: Colors.red[200], fontSize: 11.0),
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
                        "${item.lastNegotiation.quantity} ${openNegotiation.tradeUnit.shortName}",
                        style: sub,
                      ),
                      Text(
                        "₹ ${item.lastNegotiation.pricePerUnit}",
                        style: sub,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      hasChatWindow
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // OrderDetail == null > No Status, Neither Accept or reject
                                item.orderDetail == null
                                    ? Container()
                                    : Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: item.orderDetail.status ==
                                                    "Accepted"
                                                ? greenColor
                                                : redColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          "${item.orderDetail.status}",
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
    //print("Responders List: ${openNegotiation.respondersAndNegotiations.length}");
    return Container(
      padding: EdgeInsets.only(left: minValue * 2),
      color: buySellBackground,
      child: openNegotiation.respondersAndNegotiations.length != 0
          ? Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: minValue * 3, top: minValue),
                      child: Text(
                        "Responders ",
                        style: TextStyle(color: greenColor),
                      ),
                    ),
                    Icon(
                      Icons.reply,
                      color: greenColor,
                      size: 18,
                    ),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: openNegotiation.respondersAndNegotiations.length,
                    itemBuilder: (context, index) {
                      final RespondersAndNegotiations item =
                          openNegotiation.respondersAndNegotiations[index];
                      return _buildListTile(context, item);
                      return Text(
                        "${item.responder.name}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .apply(color: Colors.white60),
                      );
                    }),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.amber[200],
                  size: 12,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(minValue),
                    child: Text(
                      "Your request has not been responded yet",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: Colors.amber),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
