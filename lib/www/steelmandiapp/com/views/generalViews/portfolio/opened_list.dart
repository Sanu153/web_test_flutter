import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/open_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/portfolio_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/portfolio/reponders.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/portfolio/responded.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';

class MyOpenedList extends StatefulWidget {
  final PortfolioBloc portfolioBloc;

  MyOpenedList({@required this.portfolioBloc});

  @override
  _MyOpenedListState createState() => _MyOpenedListState();
}

class _MyOpenedListState extends State<MyOpenedList> {
  final double minValue = 8.0;
  PortfolioBloc portfolioBloc;

  int _currentIndex = -9999999;

  @override
  void initState() {
    super.initState();
    //print("Init Portfoio Execur=te");
    portfolioBloc = widget.portfolioBloc;
    _onCreate();
  }

  Future<void> _onCreate() async {
    await portfolioBloc.getOpenedPortfolio("OPENED");
  }

  Future<void> _onRefresh() {
    return _onCreate();
  }

  void _onTapp(int requestId) {
    setState(() {
      if (requestId == _currentIndex) {
        _currentIndex = -999999;
      } else {
        _currentIndex = requestId;
      }
    });
  }

  bool isRequester(UserModel requestCreater) {
    final DataManager manager = Provider.of(context).dataManager;
    final UserModel currentLoginUser = manager.authUser.user;

//    print("Responder: ${currentLoginUser.userId == requestCreater.userId}");

    return currentLoginUser.userId == requestCreater.userId;
  }

  bool whoIsLastResponder(OpenNegotiation negotiation) {
    if (negotiation.respondersAndNegotiations.length != 0) {
      return negotiation.respondersAndNegotiations[0].responder.userId ==
          negotiation.userId;
    } else {
      return false;
    }
  }

  String getDateTime(String date) =>
      DateFormat("dd MMM yy, HH:mm").format(DateTime.parse(date));

  Widget _buildListTile(int index, OpenNegotiation _openNego) {
    final title =
        Theme.of(context).textTheme.caption.apply(color: Colors.white70);
    final sub =
        Theme.of(context).textTheme.caption.apply(color: Colors.white60);

    final DataManager manager = Provider.of(context).dataManager;
    final respondedListLength = _openNego.respondersAndNegotiations.length;

    final UserModel currentLoginUser = manager.authUser.user;
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => _onTapp(_openNego.id),
          splashColor: Colors.white10,
          child: Container(
            height: 85,
//            color: redColor,
            decoration: _currentIndex == index
                ? BoxDecoration(color: buySellBackground)
                : null,
            padding: EdgeInsets.all(minValue),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor:
                      _openNego.buySell == 'Buy' ? greenColor : redColor,
                  radius: 12.0,
                  backgroundImage: NetworkImage(
                      _openNego.productSpec.dispIcon ??
                          manager.defaultProductSpecIcon),
                ),
                SizedBox(
                  width: minValue,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "${_openNego.productSpec.name ?? _openNego.productSpec.dispName}",
                          style: title,
//                              overflow: TextOverflow.ellipsis,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Text(
                        _openNego.marketHierarchy.name,
                        style: sub,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${getDateTime(_openNego.createdAt)}",
                        style:
                            TextStyle(color: Colors.red[200], fontSize: 12.0),
                      )
                    ],
                  ),
                ),
                Text(
                  " ${!isRequester(_openNego.user) ? '' : '($respondedListLength)'}",
                  style: sub,
                  overflow: TextOverflow.clip,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              _openNego.quantityRemaining.toString() +
                                  "${_openNego.tradeUnit.shortName}",
                              style: sub,
                            ),
                            Text(
                              "₹ ${_openNego.pricePerUnit.toString().length > 10 ? _openNego.pricePerUnit.toString().substring(0, 5) + '..' : _openNego.pricePerUnit.toString()}",
                              style: sub,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: minValue,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _openNego.buySell == 'Buy'
                              ? Icon(
                                  Icons.call_made,
                                  color: greenColor,
                                  size: 18,
                                )
                              : Icon(
                                  Icons.call_received,
                                  color: redColor,
                                  size: 18,
                                ),
                          Text(
                            _openNego.buySell,
                            style: TextStyle(
                                color: _openNego.buySell == 'Buy'
                                    ? greenColor
                                    : redColor),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        _openNego.id == _currentIndex
            ? isRequester(_openNego.user)
                ? Responders(
                    openNegotiation: _openNego,
                    hasChatWindow: true,
                    requestUserType: _openNego.buySell == 'Buy'
                        ? 'Seller'
                        : 'Buyer', // If I have created a Buy Request, Then Responder must be a seller
                  )
                // Me as responder
                : Responded(
                    openNegotiation: _openNego,
                    requestUserType: _openNego.buySell == 'Buy'
                        ? 'Buyer'
                        : 'Seller', //If I Have Responded A Buy Request, Then Other Party will see me as seller
                  )
            : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: StreamMania<Portfolio>(
        stream: portfolioBloc.portfolioNegotiation$,
        onWaiting: (context) => MyComponentsLoader(),
        onFailed: (context, Failure failed) => ResponseFailure(
          title: failed.responseMessage,
          hasDark: true,
        ),
        onSuccess: (context, Portfolio portfolio) {
          final List<OpenNegotiation> negotiationList =
              portfolio.listOfOpenNegotiations;
          return Container(
            child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: minValue),
                itemBuilder: (context, index) {
                  OpenNegotiation _openNego = negotiationList[index];
                  return _buildListTile(index, _openNego);
                },
                separatorBuilder: (context, index) => Divider(
                      color: Colors.blueGrey[600],
                    ),
                itemCount: negotiationList.length),
          );
        },
      ),
    );
  }
}
