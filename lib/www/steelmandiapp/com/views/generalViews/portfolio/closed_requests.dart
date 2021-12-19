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

class MyClosedRequests extends StatefulWidget {
  final PortfolioBloc portfolioBloc;

  const MyClosedRequests({this.portfolioBloc});

  @override
  _MyClosedRequestsState createState() => _MyClosedRequestsState();
}

class _MyClosedRequestsState extends State<MyClosedRequests> {
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
    await portfolioBloc.getOpenedPortfolio("CLOSED");
  }

  void _onTapp(index) {
    setState(() {
      if (index == _currentIndex) {
        _currentIndex = -999999;
      } else {
        _currentIndex = index;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    portfolioBloc = Provider.of(context).fetch(PortfolioBloc);
  }

  bool isRequester(UserModel requestCreater) {
    final DataManager manager = Provider.of(context).dataManager;
    final UserModel currentLoginUser = manager.authUser.user;

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
          onTap: () => _onTapp(index),
          splashColor: Colors.white10,
          child: Container(
            height: 75,
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
                          overflow: TextOverflow.clip,
                        ),

//
                      ),
                      Text(
                        _openNego.marketHierarchy.name,
                        style: sub,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Date: ${getDateTime(_openNego.createdAt)}",
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
                              overflow: TextOverflow.ellipsis,
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
        index == _currentIndex
            ? isRequester(_openNego.user)
                ? Responders(
                    openNegotiation: _openNego,
                    hasChatWindow: false, // Don not open chat window
                  )
                : Responded(
                    openNegotiation: _openNego,
                    hasChatWindow: false, //   Don not open chat window
                  )
            : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _onCreate();
      },
      child: StreamMania<Portfolio>(
        stream: portfolioBloc.portfolioNegotiation$,
        onWaiting: (context) => MyComponentsLoader(),
        onFailed: (context, Failure failed) => ResponseFailure(
          title: failed.responseMessage,
          hasDark: true,
        ),
        onSuccess: (context, Portfolio portfolio) {
          final List<OpenNegotiation> negotiationList =
              portfolio.listOfCLosedNegotiations;
          //print(portfolio.listOfCLosedNegotiations.length);
          return Container(
            child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: minValue * 2),
                itemBuilder: (context, index) {
                  OpenNegotiation _openNego = negotiationList[index];
                  return _buildListTile(index, _openNego);
                },
                separatorBuilder: (context, index) => Divider(
                      color: Colors.blueGrey[600],
                    ),
                itemCount:
                    negotiationList == null ? 0 : negotiationList.length),
          );
        },
      ),
    );
  }
}
