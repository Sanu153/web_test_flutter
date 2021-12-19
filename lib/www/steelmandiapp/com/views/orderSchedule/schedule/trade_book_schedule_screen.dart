import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/custom_keypad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/tradebook_schedule.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';

class ScheduleTradeBookScreen extends StatefulWidget {
  final MarketBloc marketBloc;

  ScheduleTradeBookScreen({@required this.marketBloc});

  @override
  _ScheduleTradeBookScreenState createState() =>
      _ScheduleTradeBookScreenState();
}

class _ScheduleTradeBookScreenState extends State<ScheduleTradeBookScreen> {
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _sendController = TextEditingController();

  final double minValue = 8.0;

  Future<ResponseResult> _futureResult;
  ResponseResult _result;

  int _currentIndex = -99999999;
  Action _action;
  double _selectedTextValue = 0.0;

  CurrentSchedule _currentSchedule;
  List<CurrentSchedule> _currentScheduleList;
  bool isLoading = false;
  String message = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _onCreated() async {
    _futureResult = widget.marketBloc.getTradeBookSchedule();
    _result = await _futureResult;
    if (_result.data is Success) {
      final TradeBookSchedule tradeBookSchedule = _result.data.data;
      _currentScheduleList = tradeBookSchedule.currentSchedule;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentScheduleList = List<CurrentSchedule>();
    _onCreated();
  }

  void _onSend() async {}

  void _onActionPaySend() async {
    if (_selectedTextValue == 0.0) return;

    setState(() {
      isLoading = true;
    });

    final data = {
      "order_id": _currentSchedule.orderId,
      "payment_delivery": _action == Action.PAY ? "payment" : "delivery",
      "amount_quantity": _selectedTextValue
    };
    final result = await widget.marketBloc.postAdherence(data);

    if (result.data is ResponseFlags) {
      // Success
      // remove Item from List
      final ResponseFlags _flag = result.data;
      setState(() {
        print("Success");
        message = _flag.responseMessage;
        isLoading = false;
        // Remove Item From List If Quantity Is Greater Equal To SelectedValue
        if (_selectedTextValue >=
            _currentSchedule.paymentDeliveryPendingTillDate) {
          _currentScheduleList.removeAt(_currentIndex);
        } else {
          // Update Current Shcedule Amount
          _currentSchedule.paymentDeliveryPendingTillDate -= _selectedTextValue;
          _currentSchedule.paymentDeliveryTillDate += _selectedTextValue;
          _currentScheduleList[_currentIndex] = _currentSchedule;
        }
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: greenColor,
            content: Text(
              "${_flag.responseMessage}",
              style: TextStyle(color: Colors.white),
            )));

        _selectedTextValue = 0.0;
        _currentIndex = -99999999;
      });
    } else {
      setState(() {
        _selectedTextValue = 0.0;
        isLoading = false;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: redColor,
            content: Text(
              "Failed to post",
              style: TextStyle(color: Colors.white),
            )));
        _currentIndex = -99999999;
      });
    }
  }

  void _onTapSchedule(
      CurrentSchedule schedule, Action action, int index) async {
    setState(() {
      _action = action;
      _currentSchedule = schedule;
      if (index == _currentIndex) {
        // Close Active Open Tile
        _currentIndex = -999999;
        _sendController.text = "";
        _payController.text = "";
        _selectedTextValue = 0.0;
      } else {
        _currentIndex = index;
        _selectedTextValue = 0.0;
        // Set Default Value
        if (action == Action.SEND) {
          _sendController.text =
              schedule.paymentDeliveryPendingTillDate.toString();
        } else {
          _payController.text =
              schedule.paymentDeliveryPendingTillDate.toString();
        }
      }
    });
  }

  void _onFinished(double value) {
    setState(() {
      _selectedTextValue = value;
    });
  }

  void _onPaySendTextFiledTap() {
    DialogHandler.openMyCustomKeyPadDialog(
        context: context,
        child: MyCustomNumberKeyPad(
          title: "${_action == Action.SEND ? 'QUANTITY' : 'PRICE'}",
          onFinished: _onFinished,
          hasLiveUpdate: false,
        ));
  }

  String get getTextValue =>
      "${_selectedTextValue != 0.0 ? _selectedTextValue : _action == Action.PAY ? 'Enter payment' : 'Enter delivery quantity'}";

  Widget _buildTextField(CurrentSchedule schedule) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              Text(
                "${_action == Action.PAY ? 'Total amount paid:' : 'Total quantity delivered: '}",
                style: TextStyle(
                    fontSize: 14.0,
                    color:
                        _action == Action.PAY ? Colors.lightBlue : greenColor),
              ),
              Text(
                "${schedule.paymentDeliveryTillDate}",
                style: TextStyle(
                    fontSize: 14.0,
                    color:
                        _action == Action.PAY ? Colors.lightBlue : greenColor),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () => _onPaySendTextFiledTap(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: buySellTextColor),
                  child: Text(
                    getTextValue,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
            isLoading
                ? MyComponentsLoader()
                : Container(
                    child: _action == Action.PAY
                        ? MaterialButton(
                            onPressed: () => _onActionPaySend(),
                            child: Text("PAY"),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(1),
                            height: 45,
                            minWidth: 70,
                            color: Colors.lightBlue,
                          )
                        : MaterialButton(
                            onPressed: () => _onActionPaySend(),
                            child: Text(
                              "DISPATCH",
                              style: TextStyle(fontSize: 12.0),
                            ),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(1),
                            height: 45,
                            minWidth: 70,
                            color: greenColor,
                          ),
                  ),
          ],
        ),
      ],
    ));
  }

  Widget _buildDynamicTile(CurrentSchedule schedule, int index) {
    return Container(
      padding: index == _currentIndex
          ? EdgeInsets.only(bottom: 8, left: 3, right: 3)
          : null,
      decoration: index == _currentIndex
          ? BoxDecoration(color: buySellBackground)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TradeBookScheduleTile(
            currentSchedule: schedule,
            onAction: (Action action) =>
                _onTapSchedule(schedule, action, index),
          ),
          _currentIndex == index ? _buildTextField(schedule) : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: _scaffoldKey,
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            await _onCreated();
            return true;
          },
          child: FutureObserver(
            onWaiting: (context) => MyComponentsLoader(),
            future: _futureResult,
            onError: (context, Failure failed) => ResponseFailure(
              title: "${failed.responseMessage}",
            ),
            onSuccess: (context, TradeBookSchedule tradeBookSchedule) {
              if (tradeBookSchedule.currentSchedule.length == 0)
                return ResponseFailure(
                  title: "No Data Available",
                  hasDark: true,
                  subtitle: "Make a deal",
                );
              return ListView.separated(
                  padding: EdgeInsets.symmetric(
                      vertical: minValue * 1.5, horizontal: minValue),
                  itemBuilder: (BuildContext context, int index) {
                    final CurrentSchedule _current =
                        _currentScheduleList[index];

                    return _buildDynamicTile(_current, index);
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[800],
                      ),
                  itemCount: _currentScheduleList.length);
            },
          ),
        ),
      ),
    );
  }
}

enum Action { PAY, SEND }

class TradeBookScheduleTile extends StatelessWidget {
  final CurrentSchedule currentSchedule;
  final Function onAction;

  TradeBookScheduleTile({this.currentSchedule, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "${currentSchedule.partyName}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  "${currentSchedule.partyType}",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: currentSchedule.partyType == 'Buyer'
                          ? greenColor
                          : redColor),
                ),
                SizedBox(
                  width: 3,
                ),
                currentSchedule.partyType != null &&
                        currentSchedule.partyType == 'Buyer'
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
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 4,
            ),
            Text(
              "${currentSchedule.productSpecName} (${currentSchedule.productName})",
              style: TextStyle(color: Colors.white70, fontSize: 12.0),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "Date: ${DateFormat.yMMMMd().format(DateTime.parse(currentSchedule.date))}",
              style: TextStyle(color: Colors.white70, fontSize: 12.0),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Contract No: ${currentSchedule.contractId}",
              style: TextStyle(color: Colors.white70, fontSize: 14.0),
            )
          ],
        ),
        isThreeLine: true,
        onTap: () => onAction(
            currentSchedule.action == 'Pay' ? Action.PAY : Action.SEND),
        trailing: currentSchedule.action == 'Pay'
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "${currentSchedule.paymentDeliveryPendingTillDate}",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Amount pending",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "${currentSchedule.paymentDeliveryPendingTillDate} T",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Quantity pending",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}
