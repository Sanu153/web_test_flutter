import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/custom_keypad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_spec_market_grapph.dart';

class MyPriceLiveChecker extends StatelessWidget {
  final int marketHierarchyId;
  final Function onPriceSelected;

  MyPriceLiveChecker({this.marketHierarchyId, this.onPriceSelected});

  Widget _buildNumber(String data) {
    return MyCustomNumberKeyPad(
      title: "PRICE",
      onFinished: onPriceSelected,
      data: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GraphBloc _graphBloc = Provider.of(context).fetch(GraphBloc);

    return StreamBuilder<GraphData>(
      stream: _graphBloc.currentSelectedMarketGraph$,
      builder: (context, AsyncSnapshot snapshot) {
        //print("Live Price Updating...");
        if (!snapshot.hasData) return _buildNumber('');

        GraphData lastData = snapshot.data;
        //print("Last Traded Price: ${lastData.price}");
        //print("MArketId: $marketHierarchyId");
        return _buildNumber(lastData.price.toString());
      },
    );
  }
}
