import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/custom_keypad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/success.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customState/custom_state.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/buy_sell_trade_category.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/market_list.dart';

class MyAlertViews extends StatefulWidget {
  @override
  _MyAlertViewsState createState() => _MyAlertViewsState();
}

class _MyAlertViewsState extends State<MyAlertViews> {
  final double minValue = 8.0;

  String _marketName = "MARKET";
  String _validity = "VALIDITY";
  String _message = "";
  double _priceAmount = 0.0;
  double _quantity = 0.0;
  int _marketHierarchyId = 0;

  ProductBloc _productBloc;
  MarketBloc _marketBloc;
  GraphBloc _graphBloc;

  bool hasLoading = false;
  bool showMessage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _graphBloc = Provider.of(context).fetch(GraphBloc);
    _productBloc = Provider.of(context).fetch(ProductBloc);
    _marketBloc = Provider.of(context).fetch(MarketBloc);
  }

  void _onConfirm() async {
    setState(() {
      hasLoading = true;
    });
    final int productSpecId = _productBloc.getCurrentUserProduct.productSpecId;
    final bool result = await _marketBloc.setAlert(
        price: _priceAmount,
        marketId: _marketHierarchyId,
        validity: _validity == "Once" ? "O" : "R",
        productSpecId: productSpecId);

    // Success
    setState(() {
      hasLoading = false;
      showMessage = true;
      if (result) {
        _message = "Alert Updated Successfully";
      } else {
        // failed
        _message = "Failed to update";
      }
    });
    await Future.delayed(Duration(seconds: 1));

    Navigator.of(context).pop();
  }

  void _onPriceSelected(double price) {
    //print("Price Entered: $price");
    if (!mounted) return;
    setState(() {
      _priceAmount = price;
    });
  }

  void _onCategoryTap(BuySellRequestAdder state) {
    if (state == BuySellRequestAdder.MARKET) {
      DialogHandler.openBuySellRequestDialog(
          context: context,
          child: MyBuySellMarketList(
            onSelected: _onMarketItemSelected,
          ));
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
      if (!mounted) return;
      DialogHandler.openBuySellRequestDialog(
          context: context, child: _buildValidity());
    }
  }

  void _onMarketItemSelected(List valueSet) {
    //print("Market Item Tapped: $valueSet");
    // Update Live Price With Correponding MArket
    _graphBloc.selectedMarket(valueSet[1]);
    if (!mounted) return;
    setState(() {
      _marketName = valueSet[0];
      _marketHierarchyId = valueSet[1];
    });
  }

  Widget _buildValidity() {
    final style =
        Theme.of(context).textTheme.caption.apply(color: Colors.white70);

    return Container(
      padding: EdgeInsets.symmetric(vertical: minValue * 1.2),
      child: Column(
        children: <Widget>[
          Text(
            "VALIDITY",
            style: Theme.of(context)
                .textTheme
                .subtitle
                .apply(color: Colors.white70),
          ),
          ListTile(
            dense: true,
            title: Text(
              "Once",
              style: style,
            ),
            onTap: () {
//              //print("Validity Double Tapped: ${context}");

              Navigator.of(context).pop();
              setState(() {
                _validity = "Once";
              });
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              "Always",
              style: style,
            ),
            onTap: () {
              Navigator.of(context).pop();

              setState(() {
                _validity = "Always";
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildAlertBody() {
    final width = MediaQuery.of(context).size.width;
    final trailStyle =
        Theme.of(context).textTheme.caption.apply(color: Colors.white);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
//          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              MyBuySellTradeCategory(
                onPressed: () {
                  _onCategoryTap(BuySellRequestAdder.MARKET);
                },
                title: '$_marketName',
                textColor: _marketName == "MARKET" ? null : Colors.white,
              ),
              SizedBox(
                height: minValue,
              ),
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
              SizedBox(
                height: minValue,
              ),
              MyBuySellTradeCategory(
                onPressed: () {
                  _onCategoryTap(BuySellRequestAdder.VALIDITY);
                },
                title: '$_validity',
                textColor: _validity == "VALIDITY" ? null : Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showMessage
          ? MySuccessViews(
              message: _message,
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(minValue * 1.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "SET ALERT",
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .apply(color: Colors.white70),
                            ),
                            GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                )),
                          ],
                        ),
                      ),
                      _buildAlertBody(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.maxFinite,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(minValue))),
                      onPressed: hasLoading ? null : () => _onConfirm(),
                      disabledColor: Colors.orange[200],
                      child: Text("${hasLoading ? 'LOADING' : 'CONFIRM'}"),
                      color: Colors.orange[400],
                      padding: EdgeInsets.symmetric(vertical: minValue * 1.5),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
