import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/footerViews/bottom_navigation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/graphViews/main_graph_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/add_new_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/productBar/myappbar_screens.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/splashViews/splash_screen.dart';

class MyDashboardScreen extends StatelessWidget {
  Widget _buildDashBody(BuildContext context, List<UserProduct> upL) {
    final ProductBloc productBloc = Provider.of(context).fetch(ProductBloc);
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: MyMainGraphViews(
            userProductList: upL,
          )),
          MyBuySellRequestController(
            productBloc: productBloc,
          )
        ],
      ),
    );
  }

  _onFailed(context, Failure f) {
    return ResponseFailure(
      title: f.responseMessage,
      subtitle: f.responseStatus,
      hasDark: true,
      reload: () {
        final ProductBloc _productBloc =
            Provider.of(context).fetch(ProductBloc);
        _productBloc.getInitialProduct();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
//    //print("Dashboard Context");
//    SystemConfig.makeStatusBarHide();

    final DataManager manager = Provider.of(context).dataManager;
    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);
    return StreamMania<UserProduct>(
      onWaiting: (context) {
        return SplashViews();
      },
      stream: _productBloc.userProductState$,
      onError: _onFailed,
      onFailed: _onFailed,
      onSuccess: (context, List<UserProduct> productList) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Theme.of(context).primaryColorDark,
            appBar: ProductAppBar(manager: manager),
            body: _buildDashBody(context, productList),
            bottomNavigationBar: Container(
              height: manager.coreSettings.bottomNavHeight,
              color: Theme.of(context).primaryColor,
              child: MyBottomNavigation(),
            ),
          ),
        );
      },
    );
  }
}
