import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/custom_keypad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/schedule.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/schedule/schedule_builder.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/schedule/schedule_tile.dart';

class EditScheduleScreen extends StatefulWidget {
  final List<Schedule> schedule;
  final bool isEditable;
  final int orderId;
  final Function onEditChanged;

  const EditScheduleScreen(
      {Key key,
      this.schedule,
      this.isEditable,
      this.orderId,
      this.onEditChanged})
      : super(key: key);

  @override
  _EditScheduleScreenState createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<Schedule> _editableSchedules;
  bool isEditable = false;
  int _currentIndex = -999;

  bool isLoading = false;

  void _onCreated() async {
    _editableSchedules = widget.schedule;
    isEditable = widget.isEditable;

//    print("Order Id: ${widget.orderId} \nIsEditable: $isEditable ");
  }

  void _onEditFieldTap(String type) {
    DialogHandler.openMyCustomKeyPadDialog(
        context: context,
        child: MyCustomNumberKeyPad(
            title: "$type",
            onFinished: (double value) {
              if (!mounted) return;
              setState(() {
                if (type == "Payment") {
                  _editableSchedules[_currentIndex].payment = value;
                } else {
                  _editableSchedules[_currentIndex].delivery = value;
                }
              });
            }));
  }

  void _onEditTap(Schedule schedule, int index) {
    if (index == _currentIndex) {
      setState(() {
        _currentIndex = -999;
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _onCreated();
  }

  void _onSubmit() async {
    setState(() {
      isLoading = true;
    });
    final MarketBloc _bloc = Provider.of(context).fetch(MarketBloc);
    final ResponseResult _result = await _bloc.updateSchedule(
        orderId: widget.orderId, schedules: _editableSchedules);

    if (_result.data is ResponseFlags) {
      final ResponseFlags _r = _result.data;
      print("Success");
      _showSnack("${_r.responseMessage}", false);
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isEditable = false;
        _currentIndex = -999;
      });
      widget.onEditChanged();
      return;
    } else if (_result.data is Failure) {
      final Failure f = _result.data;
      print("Failed");
      _showSnack("${f.responseMessage}", true);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showSnack(String message, bool isError) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        "$message",
        style: TextStyle(color: Colors.white70),
      ),
      backgroundColor: isError ? redColor : greenColor,
    ));
  }

  Widget _buildEditableButton() {
    return Container(
      width: double.maxFinite,
      child: RaisedButton.icon(
        onPressed: () => _onSubmit(),
        icon: Icon(Icons.save),
        label: Text("SUBMIT"),
        padding: EdgeInsets.all(10.0),
        textColor: Colors.white,
        color: Colors.blueGrey[600],
      ),
    );
  }

  Widget _buildEditWidget(Schedule _scdle) {
    return Container(
      padding: EdgeInsets.only(left: 45.0),
      margin: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () => _onEditFieldTap('Payment'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Payment",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: buySellTextColor),
                        child: Text(
                          "${_scdle.payment}",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onEditFieldTap('Delivery'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Delivery",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: buySellTextColor),
                        child: Text(
                          "${_scdle.delivery}",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
//          SizedBox(
//            height: 8.0,
//          ),
//          isLoading
//              ? MyComponentsLoader()
//              : Container(
//                  width: double.maxFinite,
//                  child: MaterialButton(
//                    onPressed: () => null,
//                    child: Text(
//                      "UPDATE",
//                      style: TextStyle(fontSize: 12.0),
//                    ),
//                    textColor: Colors.white70,
//                    padding: EdgeInsets.all(1),
//                    height: 35,
//                    color: Colors.blueGrey[700],
//                  ),
//                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_editableSchedules.length == 0)
      return Center(
        child: Text(
          "No Schedules Found",
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
      );
    return Column(
      children: <Widget>[
        ScheduleBuilder(
          schedules: _editableSchedules,
          builder: (context, int index) {
            final Schedule _scdle = _editableSchedules[index];
            return Container(
              padding: index == _currentIndex
                  ? EdgeInsets.only(bottom: 0, left: 3, right: 8, top: 16)
                  : null,
              margin:
                  index == _currentIndex ? EdgeInsets.only(bottom: 8) : null,
              decoration: index == _currentIndex
                  ? BoxDecoration(color: Color(0xff161f2e))
                  : null,
              child: Column(
                children: <Widget>[
                  ScheduleTile(
                    schedule: _scdle,
                    index: index,
                    hasActive: index == _currentIndex,
                    isEditable: isEditable,
                    onEdit: () => _onEditTap(_scdle, index),
                  ),
                  _currentIndex == index
                      ? _buildEditWidget(_scdle)
                      : Container(),
                ],
              ),
            );
          },
        ),
        isEditable
            ? isLoading ? MyComponentsLoader() : _buildEditableButton()
            : Container(),
      ],
    );
  }
}
