import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/webSocketBloc/product_socket.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellCounter/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/add_product_button.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/productBar/product_tab_list.dart';

class ProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  final DataManager manager;

  ProductAppBar({this.title, this.manager});

  @override
  Size get preferredSize => Size.fromHeight(manager.coreSettings.fromTop);

  bool isDialog = false;

  @override
  Widget build(BuildContext context) {
    double _minPadding = 8.1;
    //print("AppBar: Height: ${manager.coreSettings.fromTop}");
    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);
    final GraphBloc graphBloc = Provider.of(context).fetch(GraphBloc);
    final WebSocketBloc webSocket = Provider.of(context).fetch(WebSocketBloc);
    return AppBar(
      titleSpacing: 0,
      leading: MyAddProduct(),
      elevation: 0,
      primary: false,
      title: MyProductTabList(
        productBloc: _productBloc,
        graphBloc: graphBloc,
        webSocket: webSocket,
      ),
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
      actions: <Widget>[MySelectedMarketViews()],
    );
  }

  closeDialog() {}
}
