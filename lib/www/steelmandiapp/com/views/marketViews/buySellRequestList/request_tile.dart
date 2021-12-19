import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';

class MyRequestTile extends StatelessWidget {
  final TradeBuySellRequest item;
  final Function onTap;

  MyRequestTile({@required this.item, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ProductBloc productBloc = Provider.of(context).fetch(ProductBloc);
    final UserProduct up = productBloc.getCurrentUserProduct;
    final int userId = Provider.of(context).dataManager.authUser.user.userId;

    final t = Theme.of(context).textTheme.caption.apply(color: Colors.white60);

    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(up.productSpecIcon),
              radius: 12,
              backgroundColor: greenColor,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${up.productSpecName}",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .apply(color: Colors.white70, fontWeightDelta: 1),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "${item.marketHierarchy.name}",
                    style: TextStyle(color: Colors.white54, fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      item.thisTraderHasResponded
                          ? Icon(
                              Icons.done,
                              color: greenColor,
                              size: 14.0,
                            )
                          : item.user.userId == userId
                              ? Icon(
                                  Icons.do_not_disturb,
                                  size: 14.0,
                                  color: redColor,
                                )
                              : Container(),
                      Text(
                        "${item.user.name} ${item.user.userId == userId ? '(Me)' : ''}",
                        style: t,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${item.quantityRemaining} ${item.tradeUnit.shortName}",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  "₹ ${item.price}",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
