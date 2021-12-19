import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/sidebar_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/custom_keypad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/message_notifier.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/success.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/custom_circular_border_btn.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/dialog/custom_dialog_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellRequest/quantity_list.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';

class MyBuySellRequestFilter extends StatefulWidget {
  final TradeBuySellRequest buySellData;
  final Function onSend;

  MyBuySellRequestFilter({@required this.buySellData, this.onSend});

  @override
  _MyBuySellRequestFilterState createState() => _MyBuySellRequestFilterState();
}

enum DayCounter { PAYMENT, DELIVERY }

class _MyBuySellRequestFilterState extends State<MyBuySellRequestFilter> {
  TradeBuySellRequest buySellData;
  MarketBloc marketBloc;
  SideBarBloc sideBarBloc;

  double _price = 0.0;
  int _paymentInDay = 0;
  int _deliveryInDay = 0;
  double _totalAmount = 00.0;
  double quantityRemaining = 0;

  final double btnWidth = 51.0;

  void _onquantityRemainingTapped() {
    final height = double.infinity;
    final settings = Provider.of(context).dataManager.coreSettings;
    double dialogPositionWidth =
        settings.buySellRequestDialogWidth + settings.selectedMarketSize;
    DialogHandler.showMyCustomDialog(
        context: context,
        isBarrier: true,
        child: MyCustomBuySellDialog(
          backgroundColor: buySellBackground,
          minWidth: 120.0,
          padding: EdgeInsets.only(
              right: dialogPositionWidth + 2,
              top: settings.fromTop,
              bottom: settings.bottomNavHeight),
          elevation: 0.0,
          alignment: Alignment.topRight,
          child: SizedBox(
              width: 120.0,
              height: height,
              child: MyBuySellQuantityList(
                onSelected: (double value) {
                  print("quantityRemaining: $value");
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  setState(() {
                    quantityRemaining = value;
                  });
                },
              )),
        ));
  }

  void _onPriceChanged() {
    final height = double.infinity;
    final settings = Provider.of(context).dataManager.coreSettings;
    double dialogPositionWidth =
        settings.buySellRequestDialogWidth + settings.selectedMarketSize;

    DialogHandler.showMyCustomDialog(
        context: context,
        isBarrier: false,
        child: MyCustomBuySellDialog(
          backgroundColor: buySellBackground,
          minWidth: settings.keyPadDialogSize,
          padding: EdgeInsets.only(
              right: dialogPositionWidth + 2,
              top: settings.fromTop,
              bottom: settings.bottomNavHeight),
          elevation: 0.0,
          alignment: Alignment.topRight,
          child: SizedBox(
              width: settings.keyPadDialogSize,
              height: height,
              child: MyCustomNumberKeyPad(
                title: "PRICE",
                data: _price.toString(),
                onFinished: (double v) {
                  ////print("Price Value For Buy: $v");
                  setState(() {
                    if (v != null && v != 0.0) {
                      buySellData.price = v;
                    }

                    _price = v;
                  });
                },
              )),
        ));
  }

  void increment(DayCounter type) {
    if (type == DayCounter.DELIVERY) {
      setState(() {
        _deliveryInDay += 1;
      });
    } else {
      setState(() {
        _paymentInDay += 1;
      });
    }
  }

  void decrement(DayCounter type) {
    if (type == DayCounter.DELIVERY) {
      if (_deliveryInDay <= 0) return;
      setState(() {
        _deliveryInDay -= 1;
      });
    } else {
      if (_paymentInDay <= 0) return;

      setState(() {
        _paymentInDay -= 1;
      });
    }
  }

  updateUI() async {
    _price = buySellData.price;
//    quantityRemaining = double.parse(buySellData.quantityRemaining.toString().split(" ")[0]);
    quantityRemaining = buySellData.quantityRemaining;
    ////print("quantityRemaining: $quantityRemaining");
  }

  void _onReset() {
    setState(() {
      updateUI();
      quantityRemaining = 0.0;
      _paymentInDay = 0;
      _deliveryInDay = 0;
    });
  }

  void _onSend() async {
    ////print("BuSellId: ${buySellData.id}");
    final RespondNegotiation data = RespondNegotiation(
        quantity: quantityRemaining,
        price: _price,
        buySellRequestId: buySellData.id,
        deliveryInDays: _deliveryInDay,
        paymentsInDays: _paymentInDay,
        requestResponderId: null);
// Calling Service
    ResponseResult _result = await marketBloc.getTradeBuySellRespond(data);
    // Waiting 2sec for Displaying Message
    await Future.delayed(Duration(seconds: 2));
    // Back To Initial Widget
    marketBloc.makeInitial();
    // Update Sidebar Portfolio Icon.
    sideBarBloc.updateIcon();
    // Caliing OnSend fun tht Closes the active Tap
    // Get Data From Result
    print("${_result.data}");
    TradeBuySellRequest _trade;
    if (_result.data is Success) {
      _trade = _result.data.data[1]; // List[ResponseFlags, TradeBuySellRequest]
      print(
          "Trade Data thisTraderHasResponded: ${_trade.thisTraderHasResponded}");
      print("Trade Data: ${_trade.toJson()}");
    }
    widget.onSend(_trade);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    marketBloc = Provider.of(context).fetch(MarketBloc);
    sideBarBloc = Provider.of(context).fetch(SideBarBloc);
  }

  @override
  initState() {
    super.initState();

    // Creating New Instance Of TradeBuySellRequest;
    buySellData = TradeBuySellRequest(
        buySell: widget.buySellData.buySell,
        createdAt: widget.buySellData.createdAt,
        customRequirements: widget.buySellData.customRequirements,
        id: widget.buySellData.id,
        marketHierarchy: widget.buySellData.marketHierarchy,
        marketHierarchyId: widget.buySellData.marketHierarchyId,
        place: widget.buySellData.place,
        status: widget.buySellData.status,
        updatedAt: widget.buySellData.updatedAt,
        userId: widget.buySellData.userId,
        validUpto: widget.buySellData.validUpto,
        price: widget.buySellData.price,
        quantityRemaining: widget.buySellData.quantityRemaining,
        quantity: widget.buySellData.quantity,
        productSpec: widget.buySellData.productSpec,
        thisTraderHasResponded: widget.buySellData.thisTraderHasResponded,
        tradeUnit: widget.buySellData.tradeUnit,
        user: widget.buySellData.user,
        productSpecId: widget.buySellData.productSpecId);

    updateUI();
  }

  double minValue = 8.0;

  Widget _buildPrice() {
    final t = Theme.of(context).textTheme.caption;
    final sub = Theme.of(context).textTheme.caption;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "PRICE",
                style: sub.apply(color: buySellTextColor),
              ),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(top: minValue - 5),
                decoration: BoxDecoration(
                  color: buySellWidgetBackground,
                  borderRadius: BorderRadius.all(Radius.circular(minValue)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _onPriceChanged();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: minValue, horizontal: minValue),
                      child: Text(
                        "₹ ${_price.toStringAsFixed(2)}",
                        style: t.apply(color: Colors.white, fontWeightDelta: 1),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: minValue,
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Quantity (${buySellData.tradeUnit.shortName})",
                style: sub.apply(color: buySellTextColor),
              ),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(top: minValue - 5),
                decoration: BoxDecoration(
                  color: buySellWidgetBackground,
                  borderRadius: BorderRadius.all(Radius.circular(minValue)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onquantityRemainingTapped(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: minValue,
                      ),
                      child: Text(
                        " ${quantityRemaining.toStringAsFixed(2)} ${buySellData.tradeUnit.shortName}",
                        style: t.apply(color: Colors.white, fontWeightDelta: 1),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: minValue,
        ),
        Expanded(
          child: _buildQuantiy(),
        )
      ],
    );
  }

  Widget _buildQuantiy() {
    final t = Theme.of(context).textTheme.caption;
    final sub = Theme.of(context).textTheme.caption;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "TOTAL",
          style: sub.apply(color: buySellTextColor),
        ),
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: minValue - 5),
          decoration: BoxDecoration(
            color: buySellWidgetBackground,
            borderRadius: BorderRadius.all(Radius.circular(minValue)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => null, ////print("Tapped"),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: minValue,
                ),
                child: Text(
                  "₹ ${_price * quantityRemaining}",
                  overflow: TextOverflow.ellipsis,
                  style: t.apply(color: Colors.white, fontWeightDelta: 1),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPaymentDays() {
    final t = Theme.of(context).textTheme.subhead;
    final sub = Theme.of(context).textTheme.caption;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "PAYMENT IN DAYS",
          style: sub.apply(color: buySellTextColor),
        ),
        SizedBox(
          width: minValue,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: btnWidth,
              child: MyCustomCircleIconButton(
                onPressed: () {
                  ////print("Add Incremnet");
                  decrement(DayCounter.PAYMENT);
                },
                icon: Icons.remove,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: minValue),
                padding: EdgeInsets.symmetric(
                    vertical: minValue, horizontal: minValue * 2),
                decoration: BoxDecoration(
                  color: buySellWidgetBackground,
                  borderRadius: BorderRadius.all(Radius.circular(minValue)),
                ),
                child: Text(
                  "$_paymentInDay",
                  textAlign: TextAlign.center,
                  style: t.apply(color: Colors.white, fontWeightDelta: 1),
                ),
              ),
            ),
            SizedBox(
              width: btnWidth,
              child: MyCustomCircleIconButton(
                onPressed: () {
                  increment(DayCounter.PAYMENT);
                },
                icon: Icons.add,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildDeliveryDays() {
    final t = Theme.of(context).textTheme.subhead;
    final sub = Theme.of(context).textTheme.caption;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "DELIVERY IN DAYS",
          style: sub.apply(color: buySellTextColor),
        ),
        SizedBox(
          width: minValue,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: btnWidth,
              child: MyCustomCircleIconButton(
                onPressed: () {
                  decrement(DayCounter.DELIVERY);
                },
                icon: Icons.remove,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: minValue),
                padding: EdgeInsets.symmetric(
                    vertical: minValue, horizontal: minValue * 2),
                decoration: BoxDecoration(
                  color: buySellWidgetBackground,
                  borderRadius: BorderRadius.all(Radius.circular(minValue)),
                ),
                child: Text(
                  "$_deliveryInDay",
                  textAlign: TextAlign.center,
                  style: t.apply(color: Colors.white, fontWeightDelta: 1),
                ),
              ),
            ),
            SizedBox(
              width: btnWidth,
              child: MyCustomCircleIconButton(
                onPressed: () {
                  increment(DayCounter.DELIVERY);
                },
                icon: Icons.add,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildButtons() {
    final t = Theme.of(context).textTheme.subtitle;
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              onPressed: () => _onReset(),
              child: Text(
                "RESET",
                style: t.apply(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(minValue))),
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          SizedBox(
            width: minValue,
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () => _onSend(),
              child: Text(
                "SEND",
                style: t.apply(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(minValue))),
              color: Theme.of(context).secondaryHeaderColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildPrice(),
          SizedBox(
            height: minValue,
          ),
          _buildPaymentDays(),
          SizedBox(
            height: minValue,
          ),
          _buildDeliveryDays(),

          _buildButtons(),
//          Expanded(child: _buildPrice()),
////          SizedBox(
////            height: minValue,
////          ),
//          Expanded(child: _buildPaymentDays()),
////          SizedBox(
////            height: minValue,
////          ),
//          Expanded(child: _buildDeliveryDays()),
//          Expanded(child: _buildButtons()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MarketBloc marketBloc = Provider.of(context).fetch(MarketBloc);
    return Container(
      height: 270.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(minValue)),
        color: Theme.of(context).primaryColorDark,
      ),
      padding: EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
      child: StreamMania<List>(
        stream: marketBloc.buySellRequestResponder$,
        onInitial: (context) {
          return _buildBody();
        },
        onFailed: (context, Failure failed) {
          return MyMessageNotifier(
            message: failed.responseMessage,
            backgroundColor: Colors.redAccent,
          );
        },
        onError: (context, Failure failed) {
          return Container(
            child: Text("${failed.responseMessage}"),
          );
        },
        onWaiting: (context) {
          return MyComponentsLoader();
        },
        onSuccess: (context, List dataSet) {
          ////print("DataSet:--- $dataSet");
          ResponseFlags flags = dataSet[0];
          if (flags != null) {
            if (flags.responseStatus == 'success') {
              return MySuccessViews(
                message: flags.responseMessage,
              );
            } else {
              return _buildBody();
            }
          } else {
            return _buildBody();
          }
        },
      ),
    );
  }
}
