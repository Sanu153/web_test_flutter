import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';

class MyProductInfoViews extends StatefulWidget {
  final MarketBloc marketBloc;

//  / This Data WIll Catch when a user from ADD Product Screen taps market info button otherwise null;
  final int specId;
  final int specMarketid;

  MyProductInfoViews(
      {@required this.marketBloc, this.specId, this.specMarketid});

  @override
  _MyProductInfoViewsState createState() => _MyProductInfoViewsState();
}

class _MyProductInfoViewsState extends State<MyProductInfoViews> {
  final double minValue = 8.0;

  final String description =
      "Lorem ipsum dolor sit amet, consectetur adipiscindolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  Future<ResponseResult> _result;
  int _currentIndex = -1;

  void _onCreate() async {
    _result = widget.marketBloc.getProductAndMarket(
        specId: widget.specId, specMarketId: widget.specMarketid);
    final result = await _result;
    if (result.data is Success) {
      List dataSet = result.data.data;
      final List<ProductSpecMarket> specMarkets = dataSet[1];
      print("Length: ${specMarkets.length}");
      if (specMarkets.length != 0) {
        specMarkets.forEach((ProductSpecMarket spec) {
          if (spec.isSubscribedByTrader) {
            print("Spec: ${spec.isSubscribedByTrader}");
            _notifyIds.add(spec.id);
          }
        });
      }
    }
  }

  void onMarketTappe(index) {
    setState(() {
      if (_currentIndex == index) {
        _currentIndex = -1;
      } else {
        _currentIndex = index;
      }
    });
  }

  //Used For Notification State
  final List<int> _notifyIds = [];

  void _notificationTap(int specId, bool isSubscribed) async {
    bool result =
        await widget.marketBloc.subscribeToMarket(specId, isSubscribed);
    print("Market Subscription result: $result");
    if (!result) {
      return;
    }
    setState(() {
      if (isSubscribed) {
        // Make subscribe
        _notifyIds.add(specId);
      } else {
        _notifyIds.remove(specId);
      }
    });
  }

  bool isActiveState(ProductSpecMarket specMarket) =>
      _notifyIds.contains(specMarket.id);

  @override
  initState() {
    super.initState();
    _onCreate();
  }

  Widget _buildProductBody(ProductSpec spec) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: minValue,
          ),
          ListTile(
            dense: true,
            subtitle: Text(
              "${spec.dispName ?? ''}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Colors.white70),
            ),
            leading: CircleAvatar(
              backgroundColor: greenColor,
              radius: minValue * 1.5,
              child: Icon(
                Icons.category,
                size: 18.0,
                color: Colors.white60,
              ),
              backgroundImage:
                  spec.dispIcon == null ? null : NetworkImage(spec.dispIcon),
            ),
            title: Text(
              "${spec.name}",
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .apply(color: Colors.white70, fontWeightDelta: 1),
            ),
          ),
          ListTile(
            subtitle: Text(
              "Size: ${spec.specification.size}, "
              "Grade: ${spec.specification.grade}, Origin: ${spec.specification.origin}",
              style: TextStyle(color: Colors.white60, fontSize: 12.0),
            ),
            title: Text(
              "Specification",
              style: TextStyle(color: greenColor, fontSize: 15.0),
            ),
          ),
          ListTile(
            isThreeLine: true,
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "$description",
                softWrap: true,
                textScaleFactor: 1.1,
                style: TextStyle(color: Colors.white60, fontSize: 12.0),
              ),
            ),
            title: Text(
              "Description",
              style: TextStyle(color: greenColor, fontSize: 15.0),
            ),
          ),
          ListTile(
            title: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                onPressed: () => null,
                backgroundColor: Colors.transparent,
                tooltip: "Full Information",
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(
                      Icons.launch,
                      color: Colors.white60,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("Full Story")
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _buildMarketBody(List<ProductSpecMarket> specMarketl) {
    return specMarketl == null
        ? ResponseFailure(
            title: "No Markets Avaialble",
          )
        : ListView.separated(
            itemBuilder: (context, index) {
              final ProductSpecMarket specMarket = specMarketl[index];

              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => onMarketTappe(index),
                    splashColor: Theme.of(context).primaryColorDark,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: minValue),
                      padding: EdgeInsets.symmetric(
                          vertical: minValue * 2, horizontal: minValue),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${specMarket.marketHierarchy.name}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .apply(color: Colors.white70),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  "${specMarket.groupingName ?? ''} (${specMarket.marketHierarchy.marketType})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .apply(color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Min: ₹${specMarket.minPrice}",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .apply(color: Colors.white70),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                "Max: ₹ ${specMarket.maxPrice}",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .apply(color: Colors.white70),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "BUY: ${specMarket.counter.buyRequestCount}",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .apply(
                                        color: greenColor, fontWeightDelta: 1),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "SELL: ${specMarket.counter.sellRequestCount}",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .apply(color: redColor, fontWeightDelta: 1),
                              )
                            ],
                          ),
//                          Container(
//                            child: Icon(
//                              _currentIndex == index
//                                  ? Icons.arrow_drop_up
//                                  : Icons.arrow_drop_down,
//                              color: Colors.white38,
//                            ),
//                          )
                        ],
                      ),
                    ),
                  ),
                  _currentIndex == index
                      ? Container(
                          padding: EdgeInsets.all(minValue),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(minValue)),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Description",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: isActiveState(specMarket)
                                                ? Icon(
                                                    Icons.notifications_active,
                                                    color: greenColor,
                                                    size: 20.0,
                                                  )
                                                : Icon(
                                                    Icons.notifications_none,
                                                    color: Colors.red[200],
                                                    size: 20.0,
                                                  ),
                                            iconSize: minValue * 2.5,
                                            color: Colors.white38,
                                            onPressed: () => _notificationTap(
                                                specMarket.id,
                                                isActiveState(specMarket)
                                                    ? false
                                                    : true),
                                          ),
//                                              Icon(
//                                                Icons.star_border,
//                                                size: minValue * 2.5,
//                                                color: Colors.white38,
//                                              ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: minValue,
                              ),
                              Container(
                                child: Text(
                                  "$description",
                                  textScaleFactor: 1.1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .apply(color: Colors.white54),
//                                      softWrap: true,
                                ),
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: specMarketl.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context)
        .textTheme
        .subtitle1
        .apply(color: Colors.white70, fontWeightDelta: 1);
    return FutureObserver(
        future: _result,
        onWaiting: (context) {
          return MyComponentsLoader();
        },
        onError: (context, Failure failed) {
          //print("Error In Error");
          return ResponseFailure(
            title: failed.responseMessage,
          );
        },
        onSuccess: (context, List dataSet) {
          return DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: Column(
                  children: <Widget>[
                    TabBar(indicatorColor: Colors.white38, tabs: [
                      Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            "PRODUCT",
                            style: theme,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            "MARKET",
                            style: theme,
                          ),
                        ),
                      ),
                    ]),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          _buildProductBody(dataSet[0]),
                          _buildMarketBody(dataSet[1])
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
