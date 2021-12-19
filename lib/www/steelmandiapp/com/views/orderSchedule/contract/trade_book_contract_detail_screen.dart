import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/contract.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/order.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/directory/permission.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/notification_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/pdf/order_contract_pdf.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/adherence/adherence_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/schedule/edit_schedule.dart';

class ContractDetailScreen extends StatefulWidget {
  final Contract contract;

  final PortfolioBloc portfolioBloc;

  ContractDetailScreen({this.contract, this.portfolioBloc});

  @override
  _ContractOrderScreenState createState() => _ContractOrderScreenState();
}

class _ContractOrderScreenState extends State<ContractDetailScreen> {
  Future<ResponseResult> _futureResult;
  ResponseResult _result;
  Failure _failure;

  final double minValue = 8.0;

  bool isLoading = false;

  Order _order;
  int _currentTab = 0;

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
    if (widget.contract != null) {
      _futureResult = widget.portfolioBloc.getSchedule(widget.contract.orderId);
      _result = await _futureResult;
      if (_result.data is Success) {
        setState(() {
          _order = _result.data.data;
        });
      }
    } else {
      print("Order Id: ${widget.contract.orderId}");
    }
  }

  @override
  void initState() {
    super.initState();

    _onCreated();
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
                "${order.dispName ?? ''}",
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
              Text(
                "${widget.contract.partyType}: ${widget.contract.partyName} ",
                style: ts.apply(
                    color: widget.contract.partyType != null &&
                            widget.contract.partyType == 'Buyer'
                        ? greenColor
                        : redColor),
              ),
              SizedBox(
                width: 2.0,
              ),
              widget.contract.partyType != null &&
                      widget.contract.partyType == 'Buyer'
                  ? Icon(
                      Icons.call_made,
                      size: 16.0,
                      color: greenColor,
                    )
                  : Icon(
                      Icons.call_received,
                      size: 16.0,
                      color: redColor,
                    )
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
                  child: _buildTag("QUANTITY()", order.quantity.toString())),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(Order order) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: minValue * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          MaterialButton(
              color:
                  _currentTab == 0 ? Colors.blueGrey[800] : Colors.transparent,
              child: Text("Schedule"),
              textColor: _currentTab == 0 ? Colors.white : Colors.grey[400],
              padding: EdgeInsets.all(12.0),
              onPressed: () {
                setState(() {
                  _currentTab = 0;
                });
              }),
//          MaterialButton(
//              child: Text("Transactions"),
//              color:
//                  _currentTab == 1 ? Colors.blueGrey[800] : Colors.transparent,
//              padding: EdgeInsets.all(12.0),
//              textColor: _currentTab == 1 ? Colors.white : Colors.grey[400],
//              onPressed: () {
//                setState(() {
//                  _currentTab = 1;
//                });
//              }),
          MaterialButton(
              child: Text("Adherence"),
              color:
                  _currentTab == 1 ? Colors.blueGrey[800] : Colors.transparent,
              padding: EdgeInsets.all(12.0),
              textColor: _currentTab == 1 ? Colors.white : Colors.grey[400],
              onPressed: () {
                setState(() {
                  _currentTab = 1;
                });
              }),
        ],
      ),
    );
  }

  Widget _buildTabBody(Order order) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: minValue, horizontal: minValue * 2),
      child: [
        EditScheduleScreen(
          isEditable: !order.isScheduleApproved,
          schedule: order.schedule,
          orderId: order.id,
          onEditChanged: () {
            if (!mounted) return;
            setState(() {
              _order.isScheduleApproved = true;
            });
          },
        ),
//        AdherenceTranscationList(
//          adherences: order.adherence,
//        ),
        AdherenceScreen(
          adherence: order.adherence,
        )
      ].elementAt(_currentTab),
    );
  }

  Widget _buildTabHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: _currentTab == 2 ? 0.0 : minValue,
          horizontal: minValue * 2),
      child: Text(
        "${_currentTab == 0 ? 'Schedule details' : _currentTab == 1 ? 'Adherence details' : ''}",
        style: TextStyle(fontSize: 16.0, color: Colors.white70),
      ),
    );
  }

  Widget _buildBody(Order order) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        _buildHeaderInfo(order),
        _buildTabBar(order),
        _buildTabHeader(),
        _buildTabBody(order)
      ],
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
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(minValue),
                decoration: BoxDecoration(
                    color: widget.contract.status == "Active"
                        ? greenColor
                        : redColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "${widget.contract.status}",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 12.0,
          ),
          _order == null
              ? Container()
              : isDownloading
              ? MyComponentsLoader()
              : IconButton(
              icon: Icon(Icons.file_download),
              disabledColor: Colors.grey[600],
              tooltip: "${_order.isScheduleApproved}",
              onPressed: () => _onContractDownload()),
          SizedBox(
            width: 12.0,
          ),
        ],
      ),
      backgroundColor: filterBackground,
      body: isLoading
          ? MyComponentsLoader()
          : FutureObserver(
              onWaiting: (context) => MyComponentsLoader(),
              onError: (context, Failure f) => ResponseFailure(
                title: f.responseMessage,
              ),
              onSuccess: (context, Order order) {
                return _buildBody(order);
              },
              future: _futureResult,
            ),
    );
  }
}
