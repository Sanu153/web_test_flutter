import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/order.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/order_detail.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/directory/permission.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/notification_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/pdf/order_contract_pdf.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/schedule/edit_schedule.dart';

class ClosedContractScreen extends StatefulWidget {
  final String tradeUnit;
  final Negotiation lastNegotiation;
  final UserModel responder;
  final PortfolioBloc portfolioBloc;
  final double quantityRemaining;
  final String requestUserType;
  final String buySell;
  final OrderDetail orderDetail;

  ClosedContractScreen(
      {this.tradeUnit,
      this.lastNegotiation,
      this.responder,
      this.portfolioBloc,
      this.quantityRemaining,
      this.requestUserType,
      this.buySell,
      this.orderDetail});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ClosedContractScreen> {
  Future<ResponseResult> _futureResult;
  ResponseResult _result;
  Failure _failure;

  final double minValue = 8.0;

  bool isLoading = false;

  Order _order;

  bool isDownloading = false;
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  void _onContractDownload() async {
    if (!_order.isScheduleApproved) {
      _showSnack("Please confirm the schedule", true);

      return;
    }
    if (!await SMPermission.checkPermission()) {
      _showSnack("File storage permission required.", true);
      return;
    }
    setState(() {
      isDownloading = true;
    });
    final NotificationManager _notification =
        Provider.of(context).fetch(NotificationManager);
    final String _result =
        await ContractPDF(order: _order, notificationManager: _notification)
        .createPdf();
    if (!mounted) return;
    setState(() {
      isDownloading = false;
    });
    if (_result != null) {
      // File Downloaded Successfully
      _showSnack("File saved in $_result", false);
    } else {
      // Not
      _showSnack("Failed to save", true);
    }
  }

  void _showSnack(String message, bool isError) {
    _scafoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        "$message",
        style: TextStyle(color: Colors.white70),
      ),
      backgroundColor: isError ? redColor : greenColor,
    ));
  }

  void _onCreated() async {
    if (widget.orderDetail != null && widget.orderDetail.id != null) {
      _futureResult = widget.portfolioBloc.getSchedule(widget.orderDetail.id);
      _result = await _futureResult;
      if (_result.data is Success) {
        setState(() {
          _order = _result.data.data;
        });
      }
    } else {
      print("Order Id: ");
    }
  }

  @override
  void initState() {
    _onCreated();
    super.initState();
  }

  Widget _buildTag(String title, String value) {
    return Container(
      color: Colors.teal[700],
      height: 50.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "$value",
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
          Text(
            "$title",
            style: TextStyle(color: Colors.white70, fontSize: 10.0),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(Order order) {
    final ts = TextStyle(color: Colors.white70, fontSize: 12);

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: minValue * 2, horizontal: minValue * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Contract Details",
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Product Name: ",
                style: ts,
              ),
              Text(
                "${order.dispName}",
                style: ts,
              )
            ],
          ),
          SizedBox(
            height: 7.0,
          ),
          Text(
            "Product Spec Name: ${order.productSpecName}",
            style: ts,
          ),
          SizedBox(
            height: 7.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Row(
                children: <Widget>[
                  Text(
                    "Buyer: ${widget.buySell == 'Buy' ? order.buyer.name : order.seller.name} ",
                    style: ts.apply(color: greenColor),
                  ),
                  Icon(
                    Icons.call_made,
                    color: greenColor,
                    size: 18,
                  )
                ],
              )),
              Expanded(
                  child: Row(
                children: <Widget>[
                  Text(
                    "Seller: ${widget.buySell == 'Sell' ? order.buyer.name : order.seller.name}",
                    style: ts.apply(color: Colors.red[300]),
                  ),
                  Icon(
                    Icons.call_received,
                    color: redColor,
                    size: 18,
                  )
                ],
              ))
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: _buildTag("PRICE", order.pricePerUnit.toString())),
              Expanded(
                  child:
                      _buildTag("PAYMENT(D)", order.paymentsInDays.toString())),
              Expanded(
                  child: _buildTag(
                      "DELIVERY(D)", order.deliveryInDays.toString())),
              Expanded(
                  child: _buildTag("QUANTITY(${widget.tradeUnit})",
                      order.quantity.toString())),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Order order) {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildHeaderInfo(order),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: minValue * 2),
            child: widget.orderDetail.status == "Accepted" &&
                    order.schedule.length != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Schedule",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
                  )
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: minValue * 2),
            child: EditScheduleScreen(
              orderId: order.id,
              isEditable: !order.isScheduleApproved,
              schedule: order.schedule,
              onEditChanged: () {
                if (!mounted) return;
                setState(() {
                  _order.isScheduleApproved = true;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyOrder() {
    return Container(
      child: ResponseFailure(
        hasDark: true,
        title: "Negotiation not finalized.",
        subtitle: "For details, check history.",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        title: Text(
          "Contract",
          style: TextStyle(color: Colors.white70, fontSize: 16.0),
        ),
        elevation: 0.0,
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.orderDetail == null
                  ? Container()
                  : Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(minValue),
                      decoration: BoxDecoration(
                          color: widget.orderDetail.status == "Accepted"
                              ? greenColor
                              : redColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        "${widget.orderDetail.status}",
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                    ),
            ],
          ),
          SizedBox(
            width: 12.0,
          ),
          _order == null || widget.orderDetail.status != "Accepted"
              ? Container()
              : isDownloading
              ? MyComponentsLoader()
              : IconButton(
              disabledColor: Colors.grey[600],
              tooltip:
              "${_order.isScheduleApproved
                  ? 'Download Schedule'
                  : 'Schedule is not approved yet.'}",
              icon: Icon(Icons.file_download),
              onPressed: () => _onContractDownload()),
          SizedBox(
            width: 12.0,
          )
        ],
      ),
      backgroundColor: filterBackground,
      body: widget.orderDetail == null
          ? _buildEmptyOrder()
          : isLoading
              ? MyComponentsLoader()
              : FutureObserver(
                  onWaiting: (context) => MyComponentsLoader(),
                  onError: (context, Failure f) => ResponseFailure(
                    title: f.responseMessage,
                  ),
                  onSuccess: (context, Order order) => _buildBody(order),
                  future: _futureResult,
                ),
    );
  }
}
