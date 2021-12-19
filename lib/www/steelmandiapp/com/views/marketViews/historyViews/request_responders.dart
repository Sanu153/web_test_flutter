import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/on_success_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/request_responder.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/historyViews/chat_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';

class RequestResponders extends StatefulWidget {
  final MarketBloc marketBloc;

  RequestResponders({@required this.marketBloc});

  @override
  _RequestRespondersState createState() => _RequestRespondersState();
}

class _RequestRespondersState extends State<RequestResponders> {
  final double minValue = 8.0;
  Future<ResponseResult> _futureResult;

  void _onCreate() async {
    _futureResult = widget.marketBloc.getTradeRequestResponders();
  }

  void _makeLandScape() async {
    await SystemConfig.makeDeviceLandscape();
    await SystemConfig.makeStatusBarHide();
  }

  @override
  void dispose() {
    _makeLandScape();
    super.dispose();
  }

  @override
  void initState() {
    _makePortrait();
    _onCreate();
    super.initState();
  }

  void _makePortrait() async {
    await SystemConfig.makeDevicePotrait();
  }

  @override
  void didUpdateWidget(RequestResponders oldWidget) {
    _makePortrait();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("History", style: TextStyle(color: Colors.white))),
      body: Container(
          child: FutureObserver(
              future: _futureResult,
              onWaiting: (context) => MyComponentsLoader(),
              onError: (context, Failure f) => ResponseFailure(
                    title: f.responseMessage,
                  ),
              onSuccess: (context, List<RequestResponder> responders) {
                if (responders.length == 0)
                  return MyResponseSuccess(
                    title: "No Data Available",
                  );
                return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final RequestResponder _responder = responders[index];
                      return ResponderTile(
                        requestResponder: _responder,
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: responders.length);
              })),
    );
  }
}

class ResponderTile extends StatelessWidget {
  final RequestResponder requestResponder;

  ResponderTile({Key key, this.requestResponder}) : super(key: key);

  void _onTap(BuildContext context) {
    final PortfolioBloc _port = Provider.of(context).fetch(PortfolioBloc);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChatHistoryScreen(
                  requestResponder: requestResponder,
                  portfolioBloc: _port,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () => _onTap(context),
        title: Text(
          "${requestResponder.productSpec ?? 'Title'}",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        isThreeLine: true,
        subtitle: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 14,
                  ),
                  Text("${requestResponder.partyName}"),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.location_city,
                    size: 14,
                  ),
                  Text("${requestResponder.market}"),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
//              Expanded(
//                child: Text(
//                    "Price: ${requestResponder.pricePerUnit}  Payment: ${requestResponder.paymentsInDays}  Delivery: ${requestResponder.deliveryInDays}  Quantity: ${requestResponder.quantity}"),
//              )
            ],
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
              color:
                  requestResponder.partyType == "Buyer" ? greenColor : redColor,
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            "${requestResponder.partyType}",
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
