import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequestList/filter_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequestList/request_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';

class MySelectedProductList extends StatefulWidget {
  final bool isBuy;
  final MarketBloc marketBloc;

  MySelectedProductList({this.isBuy = false, this.marketBloc});

  @override
  _MySelectedProductListState createState() => _MySelectedProductListState();
}

class _MySelectedProductListState extends State<MySelectedProductList> {
  Future<ResponseResult> _futureResult;
  ResponseResult _result;
  MarketBloc _marketBloc;
  List<ListItem> _items;

  double minValue = 8.0;
  int _selectedIndex = -111199999;

  Future<void> _onCreate(bool update) async {
    if (update) {
      setState(() {
        _futureResult = _marketBloc.getTradeBuySellRequest(widget.isBuy);
      });
    } else {
      _futureResult = _marketBloc.getTradeBuySellRequest(widget.isBuy);
    }

    _result = await _futureResult;

    if (_result.data is Success) {
      _items = _result.data.data[1];
    }
  }

  void _onRequestTapped(TradeBuySellRequest trade, int id) {
    // When User Send The Request => trade !=null
    if (trade != null) {
      print("BuySell Request Id: ${trade.id}");

      _items.forEach((ListItem item) {
        if (item is TradeBuySellRequest) {
          if (item.id == id) {
            setState(() {
              item.thisTraderHasResponded = true;
            });
            return;
          }
        }
      });
    }

    // Make It Initial
    widget.marketBloc.makeInitial();
    if (_selectedIndex == id) {
      if (!mounted) return;
      setState(() {
        _selectedIndex = -111199999;
      });
    } else {
      setState(() {
        _selectedIndex = id;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _marketBloc = widget.marketBloc;
    _items = List<ListItem>();
    _onCreate(false);
  }

  Widget _buildHeader() {
    final settings = Provider.of(context).dataManager.coreSettings;
    Color color = widget.isBuy ? greenColor : redColor;
    return Container(
      height: settings.fromTop,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: minValue,
              ),
              Text(
                "${widget.isBuy ? 'BUY' : 'SELL'}",
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
              Icon(
                widget.isBuy ? Icons.call_made : Icons.call_received,
                color: color,
                size: 20.0,
              )
            ],
          ),
//          IconButton(
//              icon: Icon(
//                Icons.search,
//                color: Colors.white70,
//                size: 20.0,
//              ),
//              onPressed: _onSearch),
        ],
      ),
    );
  }

  Widget _buildFilterRequest(TradeBuySellRequest buySellRequest) {
    final int userId = Provider.of(context).dataManager.authUser.user.userId;
    print("BuySell Request Id: ${buySellRequest.id}");

    return Container(
      padding: _selectedIndex == buySellRequest.id
          ? EdgeInsets.only(top: minValue)
          : null,
      decoration: _selectedIndex == buySellRequest.id
          ? BoxDecoration(
              color: Color(0xff061838),
//              border: Border.all(color: Colors.grey[700], width: 2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(minValue),
                bottomRight: Radius.circular(minValue),
              ))
          : null,
      child: Column(
        children: <Widget>[
          MyRequestTile(
            onTap: () => _onRequestTapped(null, buySellRequest.id),
            item: buySellRequest,
          ),
          _selectedIndex == buySellRequest.id
              ? Padding(
                  padding: EdgeInsets.only(
                      right: minValue * 2,
                      left: minValue * 2,
                      bottom: minValue * 2),
                  child: userId == buySellRequest.userId
                      ? Container(
                          padding: EdgeInsets.only(left: 1, top: minValue * 2),
                          child: Text(
                            "Responder can't be same as Requester",
                            style: TextStyle(color: redColor, fontSize: 12),
                          ),
                        )
                      : buySellRequest.thisTraderHasResponded
                          ? Container(
                              padding:
                                  EdgeInsets.only(left: 1, top: minValue * 2),
                              child: Text(
                                "You have already responded.",
                                style: TextStyle(color: redColor, fontSize: 12),
                              ),
                            )
                          : MyBuySellRequestFilter(
                              onSend: (TradeBuySellRequest trade) =>
                                  _onRequestTapped(trade, buySellRequest.id),
                              buySellData: buySellRequest,
                            ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildList() {
    return _items.length == 0
        ? Container(
      child: ResponseFailure(
          hasDark: true,
          title: "No ${widget.isBuy ? 'buy' : 'sell'} request available"),
    )
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: buySellTextColor,
                ),
            shrinkWrap: true,
            reverse: false,
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _items[index];
              if (item is HeadingItem) {
                return Container(
                  padding: EdgeInsets.all(minValue),
                  child: Text(
                    item.time,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .apply(color: Colors.white54),
                  ),
                );
              } else if (item is TradeBuySellRequest) {
                return _buildFilterRequest(item);
              } else {
                return Container();
              }
            });
  }

  @override
  Widget build(BuildContext context) {
    return FutureObserver(
      onWaiting: (context) {
        return MyComponentsLoader();
      },
      future: _futureResult,
      onError: (context, Failure failure) {
        return Center(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: ResponseFailure(
              subtitle: failure.responseMessage ?? "Error occured",
            ),
          ),
        );
      },
      onSuccess: (context, List data) {
        final TradeRequest _tradeRequest = data[0];
        final List<ListItem> _dataFilter = data[1];

        return Container(
          child: Column(
            children: <Widget>[
              _buildHeader(),
              Flexible(
                  child: RefreshIndicator(
                      onRefresh: () {
                        return _onCreate(true);
                      },
                      child: _buildList()))
            ],
          ),
        );
      },
    );
  }

  void _onSearch() {}

  _onTapped(int index) {
    ////print(index);
  }
}
