import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/schedule.dart';

class ScheduleTile extends StatelessWidget {
  final Schedule schedule;
  final int index;
  final bool isEditable;
  final Function onEdit;
  final bool hasActive;

  ScheduleTile(
      {@required this.schedule,
      this.index,
      this.isEditable = false,
      this.hasActive,
      this.onEdit});

  String getDateFormat(String date) {
    final DateTime _time = DateTime.parse(date);
    return DateFormat.yMMMMd().format(_time);
  }

  @override
  Widget build(BuildContext context) {
    final dataStyle = TextStyle(
      color: Colors.white70,
      fontSize: 12.0,
      letterSpacing: 0.2,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      height: 70.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              "Day ${index + 1}",
              style: TextStyle(color: Colors.white70, fontSize: 14.0),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(left: 8.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey[800])),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "${getDateFormat(schedule.date)}",
                        style:
                            TextStyle(color: Colors.lightGreen, fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Payment: ${schedule.payment ?? '0.0'} (${schedule.paymentPercentage ?? '0'}%)",
                        style: dataStyle,
                      ),
                      Text(
                        "Delivery: ${schedule.delivery} (${schedule.deliveryPercentage ?? '0'}%)",
                        style: dataStyle,
                      ),
                    ],
                  ),
                ),
                isEditable
                    ? SizedBox(
                        width: 8,
                      )
                    : Container(),
                isEditable
                    ? IconButton(
                        icon: Icon(hasActive ? Icons.close : Icons.edit),
                        onPressed: onEdit,
                        color: Colors.grey[400],
                        iconSize: 18.0,
                        padding: EdgeInsets.all(4),
                      )
                    : Container()
              ],
            ),
          )),
        ],
      ),
    );
  }
}
