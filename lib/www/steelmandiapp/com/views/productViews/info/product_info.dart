import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/market_page_views.dart';

class MyProductInfo extends StatelessWidget {
  final minValue = 8.0;

  Widget _buildProductInfo(BuildContext context) {
    final ProductBloc productBloc = Provider.of(context).fetch(ProductBloc);
    final ProductSpec productSpec = productBloc.currentSelectedProductSpecG;

    final t = Theme.of(context)
        .textTheme
        .subhead
        .apply(color: greenColor, fontWeightDelta: 1);

    final Color color = Colors.white;
    final Color color2 = Colors.white70;

    return productSpec == null
        ? ResponseFailure()
        : Container(
            width: 190.0,
            height: double.maxFinite,
            decoration: BoxDecoration(
//          color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(minValue * 3))),
            padding: EdgeInsets.symmetric(
                horizontal: minValue * 2, vertical: minValue),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
//            crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Product",
                        style: t,
                      ),
                      SizedBox(
                        height: minValue * 2,
                      ),
                      Text("Name ", style: TextStyle(color: color2)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${productSpec.name}",
                          style: TextStyle(color: color)),
                      SizedBox(
                        height: minValue * 2,
                      ),
                      Text("Category ", style: TextStyle(color: color2)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${productSpec.dispName ?? ''}",
                          style: TextStyle(color: color)),
                      SizedBox(
                        height: minValue * 2,
                      ),
                      Text(
                        "Specification",
                        style: t,
                      ),
                      SizedBox(
                        height: minValue * 2,
                      ),
                      Text("Size ", style: TextStyle(color: color2)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${productSpec.specification.size}",
                          style: TextStyle(color: color)),

                      /// Grade
                      SizedBox(
                        height: minValue * 2,
                      ),
                      Text("Grade ", style: TextStyle(color: color2)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${productSpec.specification.grade}",
                          style: TextStyle(color: color)),

                      /// Origin
                      SizedBox(
                        height: minValue * 2,
                      ),
                      Text("Origin ", style: TextStyle(color: color2)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${productSpec.specification.origin ?? 'NA'}",
                          style: TextStyle(color: color)),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final ProductBloc productBloc = Provider.of(context).fetch(ProductBloc);
    final MarketBloc marketBloc = Provider.of(context).fetch(MarketBloc);

    return Container(
      child: Row(
        children: <Widget>[
          _buildProductInfo(context),
          Expanded(
            child: MyMarketPageView(
              marketBloc: marketBloc,
              productSpecId: productBloc.getCurrentUserProduct.productSpecId,
              showDetail: true,
            ),
          )
        ],
      ),
    );
  }
}
