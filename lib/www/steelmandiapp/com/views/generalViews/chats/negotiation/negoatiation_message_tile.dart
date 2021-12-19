import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';

class MyMessageTile extends StatelessWidget {
  final Negotiation negotiation;
  final bool isCurrentUser;

  /// LastAllowed => true (Only If Only Last Message of Proposer should approve or reject && Proposer Is Not A CurrentUser)
  final bool lastAllowed;
  final Function onAction;

  /// allowCurve will allow to make radius curve according to the currentUser
  final bool allowCurve;

  MyMessageTile(
      {@required this.negotiation,
      this.allowCurve = true,
      @required this.isCurrentUser,
      this.lastAllowed,
      this.onAction});

  double minValue = 8.0;

  Widget _buildBottom(BuildContext context) {
    final PortfolioBloc _port = Provider.of(context).fetch(PortfolioBloc);

    return StreamMania<ResponseFlags>(
        stream: _port.portfolioApproveReject$,
        onInitial: (context) => Container(
              margin: EdgeInsets.only(top: minValue),
              padding: EdgeInsets.symmetric(horizontal: minValue),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text("${negotiation.place ?? ''}"),
                    ),
                  ),
                  onAction == null
                      ? Container()
                      : Expanded(
                          flex: 2,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        onAction("Rejected", negotiation),
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: redColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(minValue))),
                                      child: Text("REJECT",
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12.0)),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () =>
                                      onAction("Accepted", negotiation),
                                  child: Container(
                                      padding: EdgeInsets.all(3),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: greenColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(minValue))),
                                      child: Text("ACCEPT",
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12.0))),
                                )),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
        onWaiting: (context) => MyComponentsLoader(),
        onFailed: (context, Failure f) {
          return Text(
            "${f.responseMessage ?? 'Something went wrong'}",
            style: TextStyle(color: redColor),
          );
        },
        onSuccess: (context, ResponseFlags flags) {
          //print("Coming");
          return Container(
            padding:
                EdgeInsets.symmetric(horizontal: minValue * 2, vertical: 2),
            child: Row(
              children: <Widget>[
                Text(
                  "${flags.responseMessage}",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .apply(color: Colors.white60),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: SpinKitPumpingHeart(
                    duration: Duration(seconds: 3),
                    itemBuilder: (context, index) {
                      return CircleAvatar(
                        radius: minValue * 1.5,
                        backgroundColor: greenColor,
                        child: Icon(
                          Icons.done,
                          size: minValue * 2.5,
                          color: Colors.white60,
                        ),
                      );
                    },
                  ),
                ))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final result = Theme.of(context)
        .textTheme
        .caption
        .apply(color: Colors.white, fontWeightDelta: 1);
    final tit =
        Theme.of(context).textTheme.caption.apply(color: Colors.white54);
    final borderColor = Colors.transparent;

    return Container(
      alignment: Alignment.center,
      margin: allowCurve
          ? isCurrentUser
              ? EdgeInsets.only(right: 0.0, bottom: minValue * 2, left: 70.0)
              : EdgeInsets.only(right: 70.0, bottom: minValue * 2, left: 0.0)
          : null,
      padding:
          isCurrentUser ? EdgeInsets.only(left: 4) : EdgeInsets.only(right: 4),
      height: lastAllowed ? 80.0 : 50.0,
      decoration: BoxDecoration(
          color: isCurrentUser ? chatTileOne : Color(0xff001940),
          borderRadius: allowCurve
              ? isCurrentUser
                  ? BorderRadius.only(
                      topLeft: Radius.circular(minValue * 4),
                      bottomLeft: Radius.circular(minValue * 4),
                      topRight: Radius.circular(minValue * 4))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(minValue * 4),
                      topRight: Radius.circular(minValue * 4))
              : null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(color: borderColor, width: 1.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "₹ ${negotiation.pricePerUnit}",
                        style: result,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Price",
                        style: tit,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(color: borderColor, width: 1.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "${negotiation.quantity} T",
                        style: result,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Quantity",
                        style: tit,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(color: borderColor, width: 1.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "${negotiation.paymentsInDays} D",
                        style: result,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Payment",
                        style: tit,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(color: borderColor, width: 1.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "${negotiation.deliveryInDays} D",
                        style: result,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Delivery",
                        style: tit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          lastAllowed ? _buildBottom(context) : Container()
        ],
      ),
    );
  }
}
