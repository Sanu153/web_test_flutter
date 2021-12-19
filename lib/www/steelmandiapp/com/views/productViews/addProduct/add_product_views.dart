import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/market_page_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/product_page_view.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/save_product_btn.dart';

class MyAddProductViews extends StatelessWidget {
  final double _minValue = 10.0;

  @override
  Widget build(BuildContext context) {
    final ProductBloc productBloc = Provider.of(context).fetch(ProductBloc);
    final MarketBloc marketBloc = Provider.of(context).fetch(MarketBloc);
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(bottom: _minValue),
                child: MyProductPageView(
                  productBloc: productBloc,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor)),
              ),
            ),
            Expanded(
                flex: 5,
                child: Container(
                    padding: EdgeInsets.only(bottom: _minValue),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor)),
                    child: MyMarketPageView(
                      marketBloc: marketBloc,
                    ))),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: MySaveProductSaveBtn(),
        )
      ],
    );
  }
}
