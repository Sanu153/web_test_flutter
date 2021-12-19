import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/success.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/ApiEndpoint/endpoint_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customState/custom_state.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';

class MyConfirmBuySellViews extends StatelessWidget {
  double minValue = 8.0;

  final bool hasBuy;
  final String productName;
  final int productSpecId;
  final int marketHid;
  final String marketName;
  final String placeName;
  final double quantity;
  final double priceAmount;
  final int validity;
  final Function onTap;
  final String unit;

  MyConfirmBuySellViews(
      {this.unit,
      this.onTap,
      this.hasBuy,
      this.productName,
      this.productSpecId,
      this.priceAmount,
      this.marketHid,
      this.marketName,
      this.placeName,
      this.quantity,
      this.validity});

  Widget _buildValidity(BuildContext context) {
    final t = Theme.of(context).textTheme.caption;
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 3, vertical: height > 380 ? minValue : 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  "VALIDITY:",
                  style: t.apply(color: buySellTextColor),
                ),
              ),
              Expanded(
                child: Text(
                  "${DateTime.now().add(Duration(hours: validity)).toString().substring(0, 16)}",
                  style: t.apply(color: Colors.white),
                ),
              )
            ],
          ),
//
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final t = Theme.of(context).textTheme.subtitle;

    return Padding(
      padding: EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "${hasBuy ? 'BUY' : 'SELL'}",
            style: t.apply(
                color: hasBuy ? greenColor : redColor, fontWeightDelta: 1),
          ),
          GestureDetector(
            onTap: () => onTap(BuySellRequestAdder.EDIT),
            child: Container(
              decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  border: Border.all(color: Colors.white54, width: 2)
                  ),
              child: Icon(
                Icons.edit,
                color: Colors.white54,
                size: 18.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onTap(BuySellRequestAdder.CLOSE),
            child: Container(
              decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  border: Border.all(color: Colors.white54, width: 2)
                  ),
              child: Icon(
                Icons.close,
                size: 18.0,
                color: Colors.white54,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTotalCalculation(BuildContext context) {
    final t = Theme.of(context).textTheme.caption;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: minValue - 2, vertical: minValue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "TOTAL",
            style: t.apply(color: buySellTextColor),
          ),
          Flexible(
            child: Text(
//                "₹ ${NumberFormat.decimalPattern('in').format(priceAmount * quantity)}",
                "₹ ${priceAmount * quantity}",
                overflow: TextOverflow.clip,
                style: t.apply(color: Colors.white, fontWeightDelta: 1)),
          )
        ],
      ),
    );
  }

  Widget _buildFailed(BuildContext context, Failure failed) {
    return Container(
      height: 55.0,
      color: redColor,
      padding: EdgeInsets.all(minValue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            size: 45,
            color: Colors.white70,
          ),
          Flexible(
            child: Text(
              "${failed.responseMessage}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14.0),
            ),
          ),
//          FlatButton.icon(
//              onPressed: () => onTap(BuySellRequestAdder.CLOSE),
//              icon: Icon(
//                Icons.close,
//                size: 15,
//              ),
//              label: Text("CLOSE"))
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, String msg) {
    TextStyle t = Theme.of(context).textTheme.title;
    final height = MediaQuery.of(context).size.height;
    final MarketBloc marketBloc = Provider.of(context).fetch(MarketBloc);
    return SizedBox(
      width: double.infinity,
      child: RaisedButton.icon(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(minValue)),
          color: hasBuy ? greenColor : redColor,
          onPressed: () async {
            await marketBloc.onSubmitBuySellRequest(
                productSpecId: productSpecId,
                type: hasBuy ? 'Buy' : 'Sell',
                marketHId: marketHid,
                price: priceAmount,
                quantity: quantity,
                validity: validity,
                customRequirements: '',
                place: placeName);
            await Future.delayed(Duration(seconds: 1));
            onTap(BuySellRequestAdder.SUBMIT);
          },
          textColor: Colors.white,
          icon: Icon(
            Icons.call_made,
            size: height > 380 ? 18.0 : 15.0,
          ),
          label: Padding(
            padding: EdgeInsets.all(height > 380 ? minValue * 2 : 1),
            child: Text(
              "CONFIRM",
              style: height > 380 ? null : TextStyle(fontSize: 12.0),
            ),
          )),
    );
  }

  Widget _buildListTile(BuildContext context, {String title, dynamic value}) {
    final _size = 380.0;

    final t = Theme.of(context).textTheme.caption;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: height > _size
          ? EdgeInsets.symmetric(horizontal: 3, vertical: minValue)
          : EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: height > 380
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    "$title:",
                    style: t.apply(color: buySellTextColor),
                  ),
                ),
                Expanded(
                  child: Text("$value",
                      overflow: TextOverflow.clip,
                      style: t.apply(color: Colors.white, fontWeightDelta: 1)),
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$title:",
                  style: t.apply(color: buySellTextColor),
                ),
                Text("$value",
                    overflow: TextOverflow.clip,
                    style: t.apply(color: Colors.white, fontWeightDelta: 1))
              ],
            ),
    );
  }

  Widget _buildColumn(BuildContext context, String msg) {
    return Column(
      children: <Widget>[
        _buildHeader(context),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 2),
            children: <Widget>[
              SizedBox(
                height: minValue,
              ),
              _buildListTile(context, title: "PRODUCT", value: productName),
              _buildListTile(context, title: "MARKET", value: marketName),
              _buildListTile(context,
                  title: "${hasBuy ? 'DESTINATION' : 'SOURCE'}",
                  value: placeName),
              _buildListTile(context, title: "PRICE", value: priceAmount),
              _buildListTile(context,
                  title: "QUANTITY", value: quantity.toString() + unit ?? 'T'),
              _buildValidity(context),
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: <Widget>[
                _buildTotalCalculation(context),
                _buildSubmitButton(context, msg),
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final MarketBloc marketBloc = Provider.of(context).fetch(MarketBloc);

    return Container(
      child: StreamMania<List>(
        stream: marketBloc.buySellRequest$,
        onInitial: (context) {
          return _buildColumn(context, '');
        },
        onWaiting: (context) {
          return MyComponentsLoader();
        },
        onError: (context, Failure faile) {
          return _buildFailed(context, faile);
        },
        onFailed: (context, Failure faile) {
          return _buildFailed(context, faile);
        },
        onSuccess: (context, List dataSet) {
          final ResponseFlags _flag = dataSet[0];
          if (_flag.responseStatus == ResponseStatus.SUCCESS_STATUS) {
            return MySuccessViews(
              message: _flag.responseMessage,
            );
          }
          return _buildColumn(context, _flag.responseMessage);
        },
      ),
    );
  }
}
