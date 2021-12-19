import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/custom_keypad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/responsive_size.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customState/custom_state.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/buy_sell_trade_category.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/confirm_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/market_list.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/place_lists.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/quantity_list.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/validity.dart';

class MyBuySellRequestController extends StatefulWidget {
  final ProductBloc productBloc;

  MyBuySellRequestController({Key key, this.productBloc}) : super(key: key);

  @override
  _MyBuySellRequestControllerState createState() =>
      _MyBuySellRequestControllerState();
}

class _MyBuySellRequestControllerState
    extends State<MyBuySellRequestController> {
  String _marketName = "MARKET";
  String _remarkName = "REMARKS";
  String _placeName = "PLACE";
  double _priceAmount = 0.0;
  double _quantity = 0.0;

  double _padding = 8.0;
  int _marketHierarchyId = 0;

  int _validity = 1;

  ProductBloc _productBloc;
  MarketBloc _marketBloc;
  GraphBloc _graphBloc;

  @override
  void initState() {
    super.initState();

    // Listen On ProductItemChanged in TabBar;
    _productBloc = widget.productBloc;
    _onListenProductChange();
  }

  void _onListenProductChange() {
    _productBloc.currentActiveUserProductSubject
        .listen((UserProduct userProduct) {
//      if (_productBloc.getCurrentUserProduct.generatedId ==
//          userProduct.generatedId) {
//        // Do not reset The MArket Data
//        // Because UserProduct Stream is Updated due to BuySellCount or Other Data May update
//        // Reset The MarketData if Only If the user is Changing the One Tab To Another
//        return;
//      }
      _resetCred();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _marketBloc = Provider.of(context).fetch(MarketBloc);
    _graphBloc = Provider.of(context).fetch(GraphBloc);
  }

  void _onMarketItemSelected(List valueSet) {
    print("Market Item Tapped: $valueSet");
    // Update Live Price With Correponding MArket
    _graphBloc.selectedMarket(valueSet[1]);
    if (!mounted) return;
    Navigator.of(context).pop();

    setState(() {
      _marketName = valueSet[0];
      _marketHierarchyId = valueSet[1];
    });
  }

  void _onQuantityItemSelected(double value) {
    print("Quantity Entered: $value");
    if (!mounted) return;
    Navigator.of(context).pop();

    setState(() {
      _quantity = value;
    });
  }

  void _onPlaceSelected(String place) {
    print("Place Selected: $place");
    if (!mounted) return;
    Navigator.of(context).pop();

    setState(() {
      _placeName = place;
    });
  }

  void _onPriceSelected(double price) {
    ////print("Price Entered: $price");
    if (!mounted) return;
//    Navigator.of(context).pop();

    setState(() {
      _priceAmount = price;
    });
  }

  void _onValiditySelected(int val) {
    if (!mounted) return;
    Navigator.of(context).pop();

    setState(() {
      _validity = val;
    });
  }

  void _onCategoryTap(BuySellRequestAdder state) {
    if (state == BuySellRequestAdder.MARKET) {
      DialogHandler.openBuySellRequestDialog(
          context: context,
          child: MyBuySellMarketList(
            onSelected: _onMarketItemSelected,
          ));
    } else if (state == BuySellRequestAdder.PLACE) {
      DialogHandler.openBuySellRequestDialog(
          context: context,
          child: MyBuySellPlaceList(
            onSelected: _onPlaceSelected,
          ));
//      DialogHandler.openBuyTextFieldDialog(
//          context: context, onChanged: _onPlaceSelected);
    } else if (state == BuySellRequestAdder.PRICE) {
      if (!mounted) return;
      DialogHandler.openMyCustomKeyPadDialog(
          context: context,
          child: MyCustomNumberKeyPad(
            title: "PRICE",
            onFinished: _onPriceSelected,
            hasLiveUpdate: _marketHierarchyId == 0 ? false : true,
          ));
    } else if (state == BuySellRequestAdder.VALIDITY) {
      DialogHandler.openBuySellRequestDialog(
          context: context,
          child: MyBuySellValidityList(
            onSelected: _onValiditySelected,
          ));
    } else {
      DialogHandler.openBuySellRequestDialog(
          context: context,
          child: MyBuySellQuantityList(
            onSelected: _onQuantityItemSelected,
          ));
    }
  }

  void _onConfirmBack(type) {
    ////print("Back: $type ");
    if (!mounted) return;
    if (type == BuySellRequestAdder.CLOSE) {
      Navigator.of(context).pop();

      _resetCred();
    } else if (type == BuySellRequestAdder.SUBMIT) {
      Navigator.of(context).pop();
      _resetCred();
    } else {
      Navigator.of(context).pop();
    }
    _marketBloc.makeInitial();
  }

  void _resetCred() {
    ////print("Reseted");
    if (!mounted) return;
    setState(() {
      _marketName = "MARKET";
      _remarkName = "REMARKS";
      _placeName = "PLACE";
      _priceAmount = 0.0;
      _quantity = 0.0;

      _padding = 8.0;
      _marketHierarchyId = 0;

      _validity = 1;
    });
  }

  void _onSubmit(bool isBuy) {
    UserProduct _currentProduct = _productBloc.getCurrentUserProduct;
    ////print("Product anme:$_priceAmount + $_placeName + $_marketName  + $_quantity");
    if (_priceAmount == 0.0 || _quantity == 0.0 || _marketName == 'MARKET')
      return;

    DialogHandler.confirmBuySellDialog(
        context: context,
        isBar: true,
        child: MyConfirmBuySellViews(
          unit: "T",
          // Get Unit From Graph API Data
          productSpecId: _currentProduct.productSpecId,
          marketHid: _marketHierarchyId,
          marketName: _marketName,
          placeName: _placeName,
          priceAmount: _priceAmount,
          productName: _currentProduct.productSpecName ??
              _currentProduct.productSpecDisplayName,
          quantity: _quantity,
          validity: _validity,
          hasBuy: isBuy,
          onTap: _onConfirmBack,
        ));
    _marketBloc.makeInitial();
  }

  // Get Dashboard Content Height

  Widget _buildTotalValue(BuildContext context) {
    TextStyle t = Theme.of(context).textTheme.caption;
    TextStyle v = Theme.of(context)
        .textTheme
        .body2
        .apply(color: Colors.white, fontWeightDelta: 1);
    return Container(
      height: 40.0,
      padding: EdgeInsets.only(top: _padding, right: _padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "TOTAL",
                  textAlign: TextAlign.left,
                  style: t.apply(color: buySellTextColor),
                ),
                Expanded(
                  child: Text(
                    "₹ ${NumberFormat.compact().format(_quantity * _priceAmount)}",
//                    "₹ ${_quantity * _priceAmount}",
                    textAlign: TextAlign.right,
                    style: v.apply(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: 65.0,
              height: 55.0,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(_padding - 3)),
              ),
              child: GestureDetector(
                onTap: () => _onCategoryTap(BuySellRequestAdder.VALIDITY),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "VALIDITY",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: buySellTextColor, fontSize: 10.0),
                    ),
                    Expanded(
                      child: Text(
                        "$_validity Hr",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton() {
    TextStyle t = Theme.of(context)
        .textTheme
        .subhead
        .apply(color: Colors.white, fontWeightDelta: 1);
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_padding)),
        color: greenColor,
        onPressed: () => _onSubmit(true),
        textColor: Colors.white,
        child: Container(
          height: 55.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.call_made),
              Text(
                "BUY",
                style: t,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSellButton() {
    TextStyle t = Theme.of(context)
        .textTheme
        .subhead
        .apply(color: Colors.white, fontWeightDelta: 1);
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_padding)),
        color: redColor,
        onPressed: () => _onSubmit(false),
        textColor: Colors.white,
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          height: 55.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.call_received),
              Text(
                "SELL",
                style: t,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBuySellCategoryChildren() {
    final or = MediaQuery.of(context).orientation;
    final trailStyle =
        Theme.of(context).textTheme.caption.apply(color: Colors.white);
    return [
      MyBuySellTradeCategory(
        onPressed: () {
          _onCategoryTap(BuySellRequestAdder.MARKET);
        },
        title: '$_marketName',
        textColor: _marketName == "MARKET" ? null : Colors.white,
      ),
//
      MyBuySellTradeCategory(
        onPressed: () {
          _onCategoryTap(BuySellRequestAdder.PLACE);
        },
        title: '$_placeName',
        textColor: _placeName == "PLACE" ? null : Colors.white,
      ),
//
      MyBuySellTradeCategory(
        onPressed: () {
          _onCategoryTap(BuySellRequestAdder.PRICE);
        },
        title: 'PRICE',
        trailing: _priceAmount == 0
            ? Text("")
            : Text(
                "${_priceAmount.toStringAsFixed(1)}",
                overflow: TextOverflow.ellipsis,
                style: trailStyle,
              ),
      ),
//
      MyBuySellTradeCategory(
        onPressed: () {
          _onCategoryTap(BuySellRequestAdder.QUANTITY);
        },
        title: 'QUANTITY',
        trailing: _quantity == 0
            ? Text("")
            : Text(
                "${_quantity.toStringAsFixed(2)} T",
                overflow: TextOverflow.ellipsis,
                style: trailStyle,
              ),
      ),
    ];
  }

  List<Widget> _buildButtonChildren() {
    return <Widget>[
      SizedBox(
        height: _padding,
      ),
      _buildTotalValue(context),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(child: _buildBuyButton()),
            SizedBox(
              height: _padding,
            ),
            Flexible(child: _buildSellButton()),
          ],
        ),
      ),
    ];
  }

  List<Widget> _getBuilderList() {
//    final List<Widget> _list = [];
    return [
      SizedBox(
        height: _padding,
      ),
      _buildTotalValue(context),
      _buildBuyButton(),
      SizedBox(
        height: _padding,
      ),
      _buildSellButton()
    ];
  }

  Widget _buildBuySellBody(BuildContext context) {
    final or = MediaQuery.of(context).orientation;
    final trailStyle =
        Theme.of(context).textTheme.caption.apply(color: Colors.white);

    return or == Orientation.portrait
        ? Container()
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
            final layoutHeight = boxConstraints.biggest.height;
//            print("Layout Height: $layoutHeight");
//            print(
//                "Responsive Height: ${ResponsiveSize.dashboardContentHeight}");
            if (layoutHeight < ResponsiveSize.dashboardContentHeight) {
              return Container(
                height: ResponsiveSize.dashboardContentHeight,
                child: ListView(children: [
                  ..._buildBuySellCategoryChildren(),
                  ..._getBuilderList()
                ]),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buildBuySellCategoryChildren(),
                  ),
                ),
                Expanded(
//          alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: _buildButtonChildren(),
                    ),
                  ),
                ),
              ],
            );
          });
  }

  @override
  Widget build(BuildContext context) {
    final DataManager settings = Provider.of(context).dataManager;

    return Container(
//      color: buySellBackground,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            graphBackground1,
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColorDark
          ])),
      padding: EdgeInsets.symmetric(horizontal: _padding),
      width: settings.coreSettings.selectedMarketSize,
      height: MediaQuery.of(context).size.height -
          (settings.coreSettings.fromTop +
              settings.coreSettings.bottomNavHeight),
      child: _buildBuySellBody(context),
    );
  }
}
