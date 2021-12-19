import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/add_product_views.dart';

class MyAddProduct extends StatelessWidget {
  final Function onTap;

  MyAddProduct({
    this.onTap,
  });

  final double iconSize = 27.0;

  bool isDialog = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark, shape: BoxShape.rectangle),
      child: Material(
        color: Colors.transparent,
        child: SpinKitPumpingHeart(
          duration: Duration(seconds: 4),
          itemBuilder: (context, index) {
            return IconButton(
                icon: Icon(
                  Icons.add,
                  size: iconSize,
                ),
                onPressed: () {
//            openProductList();
                  neverSatisfied(context);
                });
          },
        ),
      ),
    );
  }

  neverSatisfied(BuildContext context) async {
    //print("Dialog Opened");
    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);
    final MarketBloc marketBloc = Provider.of(context).fetch(MarketBloc);

    DialogHandler.openGeneralDialog(
            context: context, title: "Add Product", child: MyAddProductViews())
        .then((dynamic d) {
      _productBloc.resetToDefaultData();
      marketBloc.dispose();

      //print("Dialog Closed");
    });
  }
}
