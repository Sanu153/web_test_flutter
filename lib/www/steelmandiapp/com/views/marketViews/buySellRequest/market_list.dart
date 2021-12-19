import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';

class MyBuySellMarketList extends StatelessWidget {
  final Function onSelected;

  MyBuySellMarketList({@required this.onSelected});

  String _selectedItem = "MARKET";
  int _selectedIndex = 0;

  double minValue = 8.0;

  Widget _buildList(BuildContext context) {
    ProductBloc productBloc = Provider.of(context).fetch(ProductBloc);
    UserProduct _up = productBloc.getCurrentUserProduct;
    ////print("Up: ${_up.generatedId}");
    final t = Theme.of(context)
        .textTheme
        .caption
        .apply(color: Colors.white70, fontWeightDelta: 1);
    return ListView.builder(
        itemCount: _up.productSpecMarketList.length,
        itemBuilder: (context, index) {
          final Map<int, List> _mapMarketData = _up.productSpecMarketList;
          int _marketSpecId = _mapMarketData.keys.elementAt(index);
          final List _valueSet = _mapMarketData[_marketSpecId];
          return InkWell(
            onDoubleTap: () => onSelected(_mapMarketData[_marketSpecId]),
            onTap: () {
              onSelected(_mapMarketData[_marketSpecId]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: minValue, horizontal: minValue * 1.2),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_city,
                    size: 14.0,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      "${_valueSet[0]}",
                      style: t,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
          child: Text(
            "MARKETS",
            style: Theme.of(context)
                .textTheme
                .subtitle
                .apply(color: Colors.white70),
          ),
        ),
        Expanded(child: _buildList(context)),
      ],
    );
  }
}
