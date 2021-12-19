import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/dialog/custom_dialog_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequestList/request_product_list.dart';

class MySelectedSellViews extends StatelessWidget {
  final int sellCount;

  MySelectedSellViews({@required this.sellCount});

  @override
  Widget build(BuildContext context) {
    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);
    final BuySellCount _counter = _productBloc.getCurrentUserProduct.counter;

    final sellStyle =
    Theme
        .of(context)
        .textTheme
        .subtitle
        .apply(color: redColor);
    final noStyle = Theme
        .of(context)
        .textTheme
        .subhead
        .apply(color: Colors.white, fontWeightDelta: 1);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme
            .of(context)
            .splashColor,
        onTap: () {
          //////////print("SELL");
          _openDialog(context);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "SELL",
                style: sellStyle,
              ),
              Text(
                "$sellCount",
                style: noStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openDialog(BuildContext context) {
    final height = double.infinity;
    final settings = Provider
        .of(context)
        .dataManager
        .coreSettings;
    final MarketBloc marketBloc = Provider.of(context).fetch(MarketBloc);

    DialogHandler.showMyCustomDialog(
        context: context,
        child: MyCustomBuySellDialog(
          padding: EdgeInsets.only(
            right: settings.selectedMarketSize + 1,
          ),
          alignment: Alignment.topRight,
          child: SizedBox(
              width: settings.buySellRequestDialogWidth,
              height: height,
              child: MySelectedProductList(
                isBuy: false,
                marketBloc: marketBloc,
              )),
        ));
  }
}
