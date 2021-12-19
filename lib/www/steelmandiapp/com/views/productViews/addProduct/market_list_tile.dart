import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/info/info_views.dart';

class MyMarketListTile extends StatefulWidget {
  final ProductSpecMarket productSpecMarket;
  final bool isSelected;

  MyMarketListTile({@required this.productSpecMarket, this.isSelected});

  @override
  _MyMarketListState createState() => _MyMarketListState();
}

class _MyMarketListState extends State<MyMarketListTile> {
  final double minValue = 8.0;
  ProductSpecMarket _productSpecMarket;

//  List<int> _productSpecMarketIds;
  Map<int, List> _mapMarkets;
  int _currentSpecMarketId;

  List<int> _notifySpecMarketIds;
  int _currentNotifyId;
  DataManager _dataManager;

  MarketBloc _marketBloc;

  @override
  void initState() {
    super.initState();
    _productSpecMarket = widget.productSpecMarket;
//    _productSpecMarketIds = List<int>();
    _notifySpecMarketIds = List<int>();
    _mapMarkets = Map<int, List>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataManager = Provider.of(context).dataManager;
    _marketBloc = Provider.of(context).fetch(MarketBloc);

    if (widget.isSelected) {
      onProductSpecMarketTapped();
    }
  }

  void _onInfo() {
//    Scaffold.of(context).showSnackBar(_showSnacks("Work is going on."));
    Navigator.of(context).pop();
    DialogHandler.showMyBottomSidebarDialog(
        context: context,
        child: Container(
          child: MyProductInfoViews(
            marketBloc: _marketBloc,
            specId: _productSpecMarket.id,
            specMarketid: _productSpecMarket.marketHierarchyId,
          ),
        ));
  }

  void _onNotify() async {
    _currentNotifyId = _productSpecMarket.id;

    bool _notify = _productSpecMarket.isSubscribedByTrader ? false : true;
    bool result =
        await _marketBloc.subscribeToMarket(_currentNotifyId, _notify);
    if (!result) {
      return;
    }
    setState(() {
      _productSpecMarket.isSubscribedByTrader = _notify;
      if (_notifySpecMarketIds.contains(_currentNotifyId)) {
        _notifySpecMarketIds.remove(_currentNotifyId);
        _dataManager.notifyMarketListIds.add(_currentNotifyId);

//        Scaffold.of(context)
//            .showSnackBar(_showSnacks("You just removed notification."));
      } else {
        _notifySpecMarketIds.add(_currentSpecMarketId);
        _dataManager.notifyMarketListIds.add(_currentSpecMarketId);

//        Scaffold.of(context)
//            .showSnackBar(_showSnacks("You just added notification."));
      }
    });
  }

  // On Spec Market Item Tapped
  void onProductSpecMarketTapped() {
    _currentSpecMarketId = _productSpecMarket.id;
    setState(() {
      if (_mapMarkets.containsKey(_currentSpecMarketId)) {
        _mapMarkets.remove(_currentSpecMarketId);
        _dataManager.mapMarketIdWithName.remove(_currentSpecMarketId);
      } else {
        final list = [
          _productSpecMarket.marketHierarchy.name,
          _productSpecMarket.marketHierarchyId
        ];
        _mapMarkets[_currentSpecMarketId] = list;
        _dataManager.mapMarketIdWithName[_currentSpecMarketId] = [
          _productSpecMarket.marketHierarchy.name,
          _productSpecMarket.marketHierarchyId
        ];
      }
      //print("Selected Data: ${_dataManager.mapMarketIdWithName}");
//      _marketBloc.shouldVisibleSaveButton();
    });
  }

  Widget _buildCheckbox() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: minValue),
//          decoration: BoxDecoration(
//            border: Border.all(color: Colors.white60, width: 2),
//            shape: BoxShape.rectangle,
//          ),
//        padding: EdgeInsets.all(1),
          height: 22.0,
          width: 22.0,
          child: _mapMarkets.containsKey(_currentSpecMarketId)
              ? Icon(
                  Icons.done,
                  size: 25,
                  color: Colors.white70,
                )
              : Container(),
//          Icon(
//            Icons.add,
//            size: 25,
//            color: Colors.white70,
//          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      margin: EdgeInsets.only(top: 2, bottom: 2),
      height: 45.0,
      decoration: BoxDecoration(
          color: _mapMarkets.containsKey(_currentSpecMarketId)
              ? Color(0xff021430)
              : Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(minValue),
              bottomLeft: Radius.circular(minValue),
              topRight: Radius.circular(minValue * 3),
              bottomRight: Radius.circular(minValue * 3))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onProductSpecMarketTapped(),
          splashColor: Color(0xff021430),
          child: MediaQuery.of(context).orientation != Orientation.landscape
              ? Container()
              : Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildCheckbox(),
                            SizedBox(
                              width: minValue,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "${_productSpecMarket.marketHierarchy.name}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .apply(color: Colors.white70),
                                ),
                                Text(
                                  "${_productSpecMarket.marketHierarchy.marketType}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .apply(color: Colors.white60),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "${_productSpecMarket.minPrice}",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .apply(color: Colors.white60, fontWeightDelta: 1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "${_productSpecMarket.maxPrice}",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .apply(color: Colors.white60, fontWeightDelta: 1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => _onNotify(),
                            child: _productSpecMarket.isSubscribedByTrader ||
                                    _notifySpecMarketIds
                                        .contains(_currentNotifyId)
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
                          ),
                          SizedBox(
                            width: minValue,
                          ),
                          GestureDetector(
                            onTap: () => _onInfo(),
                            child: Icon(
                              Icons.info,
                              color: Colors.white60,
                              size: 20.0,
                            ),
                          ),
                        ],
                      )),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHeaderRow();
  }
}
