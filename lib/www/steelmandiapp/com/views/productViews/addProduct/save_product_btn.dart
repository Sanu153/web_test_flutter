import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/webSocketBloc/product_socket.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';

class MySaveProductSaveBtn extends StatelessWidget {
  final double _minValue = 8.0;

  final bool showDetail;

  MySaveProductSaveBtn({this.showDetail = false});

  @override
  Widget build(BuildContext context) {
    final GraphBloc graphBloc = Provider.of(context).fetch(GraphBloc);
    final ProductBloc productBloc = Provider.of(context).fetch(ProductBloc);
    final WebSocketBloc webSocket = Provider.of(context).fetch(WebSocketBloc);
    return Container(
        margin: EdgeInsets.only(bottom: _minValue, right: _minValue * 2),
        child: FloatingActionButton(
          onPressed: () async {
            if (showDetail) {
              // Update Filter MArkets
              await productBloc.filterProductSpecMarket();
            } else {
              await productBloc.addProductFromAdder();
            }

            Navigator.of(context).pop();
            await graphBloc.getProductSpecMarketGraph();
            webSocket.onChangeProduct();
          },
          child: Icon(
            Icons.save,
            color: Colors.white60,
          ),
        ));
  }
}
