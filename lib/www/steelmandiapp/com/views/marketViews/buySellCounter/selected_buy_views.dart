import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/dialog/custom_dialog_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequestList/request_product_list.dart';

class MySelectedBuyViews extends StatelessWidget {
  final int buyCount;

  MySelectedBuyViews({@required this.buyCount});

  @override
  Widget build(BuildContext context) {
    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);
    final BuySellCount _counter = _productBloc.getCurrentUserProduct.counter;
    final buyStyle =
        Theme.of(context).textTheme.subtitle.apply(color: greenColor);
    final sellStyle =
        Theme.of(context).textTheme.subtitle.apply(color: redColor);
    final noStyle = Theme.of(context)
        .textTheme
        .subhead
        .apply(color: Colors.white, fontWeightDelta: 1);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        onTap: () {
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
                "BUY",
                style: buyStyle,
              ),
              Text(
                "$buyCount",
                style: noStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  _builder(BuildContext context) {}

  void _openDialog(BuildContext context) {
    final height = double.infinity;
    final settings = Provider.of(context).dataManager.coreSettings;
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
                isBuy: true,
                marketBloc: marketBloc,
              )),
        ));
  }
}
