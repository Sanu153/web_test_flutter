import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellCounter/selected_buy_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellCounter/selected_sell_views.dart';

class MySelectedMarketViews extends StatelessWidget {
  final double _minValue = 8.0;

  Widget _buildSelectedMarket(BuildContext context) {
    final DataManager settings = Provider
        .of(context)
        .dataManager;
    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);

    final mStyle = Theme
        .of(context)
        .textTheme
        .caption
        .apply(color: buySellTextColor, fontWeightDelta: 1);

    return Container(
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .secondaryHeaderColor,
        border: Border.all(color: Colors.blueGrey[900], width: 2),
        borderRadius: BorderRadius.all(Radius.circular(_minValue)),
      ),
      width: settings.coreSettings.selectedMarketSize,
      child: StreamBuilder<UserProduct>(
          stream: _productBloc.currentActiveUserProduct$,
          builder: (context, snapshot) {
            final UserProduct userProduct = snapshot.data;
            if (userProduct == null) return MyComponentsLoader();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: MySelectedBuyViews(
                    buyCount: userProduct.counter.buyRequestCount,
                  ),
                ),
                Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Market",
                        style: mStyle,
                      ),
                    )),
                Flexible(
                  child: MySelectedSellViews(
                      sellCount: userProduct.counter.sellRequestCount),
                ),
              ],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSelectedMarket(context);
  }
}
