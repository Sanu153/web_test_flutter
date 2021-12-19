import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_state.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/observer.dart';

class MyProductSpecMarket extends StatefulWidget {
  final int productSpecId;
  final Function onChanged;

  MyProductSpecMarket({
    @required this.productSpecId,
    @required this.onChanged,
  });

  @override
  _MyProductSpecMarketState createState() => _MyProductSpecMarketState();
}

class _MyProductSpecMarketState extends State<MyProductSpecMarket> {
  double minValue = 8.0;

  ///This is only for restrict api call

  ProductBloc productBloc;
  DataManager _dataManager;
  Future<ResponseResult> _result;

  List<int> _ids;
  Map<int, List> _mapMarketList;

  ScrollController _scrollController;

  bool _hasBefore = false;
  bool _hasNext = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _mapMarketList = Map<int, List>();
  }

  void _onScroll() {
    double min = _scrollController.position.minScrollExtent;
    double max = _scrollController.position.maxScrollExtent;
    double test = _scrollController.offset;
    //print(test);
    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _hasBefore = false;
        _hasNext = true;
      });
    }
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _hasBefore = true;
        _hasNext = false;
      });
    }
  }

  void _onCreated() async {
    //print("OnCreated MArketSpec");
    //  Call API
    _result = productBloc.getProductSpecMarket(widget.productSpecId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //print("didChangeDependencies ----------------------------");
    productBloc = Provider.of(context).fetch(ProductBloc);
    _dataManager = Provider
        .of(context)
        .dataManager;
    _onCreated();
  }

  void _goToNext() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    setState(() {
      _hasBefore = true;
      _hasNext = false;
    });
  }

  void _goToBefore() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    setState(() {
      _hasBefore = false;
      _hasNext = true;
    });
  }

  void _onTapped(ProductSpecMarket specMarket) {
    if (_dataManager.selectedProductSpecMarket.length == 0) {
      // Making empty => So That Previous Filtered data Will Not Exist;
      _mapMarketList = {};
    }
    if (_dataManager.selectedProductSpecMarket.contains(specMarket)) {
      setState(() {
        _dataManager.selectedProductSpecMarket.remove(specMarket);
        _mapMarketList.remove(specMarket.id);
      });
    } else {
      setState(() {
        _dataManager.selectedProductSpecMarket.add(specMarket);
      });
    }

    _dataManager.selectedProductSpecMarket.forEach((spec) {
      //print(spec);

      _mapMarketList[spec.id] = [
        spec.marketHierarchy.name,
        spec.marketHierarchyId
      ];
    });
    //print(_mapMarketList);

    widget.onChanged(_mapMarketList);
  }

  bool isSelected(ProductSpecMarket specMarket) {
    bool result = false;
    if (_dataManager.selectedProductSpecMarket == null) {
      result = false;
    } else if (_dataManager.selectedProductSpecMarket.contains(specMarket)) {
      result = true;
    }
    return result;
  }

  Widget _buildCard(ProductSpecMarket market, int index) {
    return Card(
      margin: EdgeInsets.only(
          left: minValue, right: minValue * 2, bottom: minValue * 3),
      elevation: isSelected(market) ? 10.0 : 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(minValue))),
      child: InkWell(
        onTap: () => _onTapped(market),
//        radius: minValue * 2,
        child: Container(
          width: 150.0,
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${market.marketHierarchy.name}",
                      style: Theme
                          .of(context)
                          .textTheme
                          .subhead
                          .apply(fontWeightDelta: 1),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(
                      height: minValue,
                    ),
                    Text(
                      "${market.groupingName}",
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle
                          .apply(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: isSelected(market)
                    ? Checkbox(
                    value: true, onChanged: (bool t) => _onTapped(market))
                    : Checkbox(
                    value: false, onChanged: (bool t) => _onTapped(market)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketBody() {
    final List<ProductSpecMarket> listData =
        Provider
            .of(context)
            .dataManager
            .productSpecMarketL;
    return Container(
      height: 210.0,
      child: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: minValue * 2, vertical: minValue),
              child: Text(
                "Market Specifications",
                style: Theme
                    .of(context)
                    .textTheme
                    .subhead,
              ),
            ),
            SizedBox(
              height: minValue,
            ),
            Expanded(
              child: listData.length == 0
                  ? ResponseFailure(
                subtitle: "No Markets available",
              )
                  : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: minValue),
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    ProductSpecMarket _specMarket = listData[index];
                    return _buildCard(_specMarket, index);
                  }),
            ),
            SizedBox(
              height: minValue,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: _hasBefore
              ? SpinKitPumpingHeart(
            duration: Duration(seconds: 3),
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: IconButton(
                    icon: Icon(
                      Icons.navigate_before,
                      size: 32.0,
                      color: Colors.grey[600],
                    ),
                    onPressed: () => _goToBefore()),
              );
            },
          )
              : Container(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _hasNext
              ? SpinKitPumpingHeart(
            duration: Duration(seconds: 3),
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      size: 32.0,
                      color: Colors.grey[600],
                    ),
                    onPressed: () => _goToNext()),
              );
            },
          )
              : Container(),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer<ProductState>(
      stream: productBloc.productSpecMArket$,
      onError: (context, error) {
        return ResponseFailure();
      },
      onSuccess: (context, ProductState state) {
        //print(state);
        if (state == ProductState.LOADER)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (state == ProductState.FAILED) return ResponseFailure();
//        _ids = [];

        /// Everty Time ProductSpec Change => Initialize To Empty
        return _buildMarketBody();
      },
    );
  }
}
