//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
//import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/adherence.dart';
//
//class AdherenceTranscationList extends StatelessWidget {
//  final List<Adherence> adherences;
//
//  AdherenceTranscationList({this.adherences});
//
//  @override
//  Widget build(BuildContext context) {
//    if (adherences.length == 0)
//      return ResponseFailure(
//        title: "No Data Available",
//        hasDark: true,
//      );
//    return ListView.separated(
//        shrinkWrap: true,
//        physics: ClampingScrollPhysics(),
//        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
//        itemBuilder: (BuildContext context, int index) {
//          final Adherence _ad = adherences[index];
//          return AdherenceTile(
//            adherence: _ad,
//          );
//        },
//        separatorBuilder: (context, index) => Divider(
//              color: Colors.grey[50],
//            ),
//        itemCount: adherences.length);
//  }
//}
//
//class AdherenceTile extends StatelessWidget {
//  final Adherence adherence;
//
//  AdherenceTile({this.adherence}) : assert(adherence != null);
//
//  String getDateFormat(String date) {
//    final DateTime _time = DateTime.parse(date);
//    return DateFormat.yMMMMd().format(_time);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final dataStyle = TextStyle(
//      color: Colors.white70,
//      fontSize: 12.0,
//      letterSpacing: 0.2,
//    );
//
//    return Container(
//      height: 70.0,
//      margin: EdgeInsets.only(bottom: 2),
//      child: Row(
//        children: <Widget>[
//          Expanded(
//              child: Container(
//            padding: EdgeInsets.only(left: 0),
////            decoration:
////                BoxDecoration(border: Border.all(color: Colors.grey[800])),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Text(
//                  "${getDateFormat(adherence.date)}",
//                  style: TextStyle(color: Colors.white70, fontSize: 14.0),
//                ),
//                SizedBox(
//                  height: 2,
//                ),
//                Text(
//                  "${adherence.paymentDelivery == 'payment' ? 'Amount: ' : 'Quantity: '} ${adherence.amountQuantity}",
//                  style: TextStyle(color: Colors.white70, fontSize: 12.0),
//                ),
//                SizedBox(
//                  height: 2,
//                ),
//                Text(
//                  "Sender: ${adherence.sender}",
//                  overflow: TextOverflow.ellipsis,
//                  style: TextStyle(color: Colors.white70, fontSize: 12.0),
//                ),
//
//                SizedBox(
//                  height: 2,
//                ),
//                Text(
//                  "Receiver: ${adherence.receiver}",
//                  overflow: TextOverflow.ellipsis,
//                  style: TextStyle(color: Colors.white70, fontSize: 12.0),
//                ),
//
////                    Text(
////                      "Payment: ${schedule.payment ?? '0.0'} (${schedule
////                          .paymentPercentage ?? '0'}%)",
////                      style: dataStyle,
////                    ),
////                    Text(
////                      "Delivery: ${schedule.delivery} (${schedule
////                          .deliveryPercentage ?? '0'}%)",
////                      style: dataStyle,
////                    ),
//              ],
//            ),
//          )),
//          Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Container(
//                width: 75.0,
//                padding: EdgeInsets.all(4),
//                alignment: Alignment.center,
//                child: Text(
//                  "${adherence.paymentDelivery == 'payment' ? 'PAID' : 'DELIVERED'}",
//                  style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      color: Colors.white,
//                      fontSize: 10.0),
//                ),
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(12.0),
//                  color: adherence.paymentDelivery == 'payment'
//                      ? Colors.lightBlue
//                      : greenColor,
//                ),
//              ),
//              SizedBox(
//                height: 3,
//              ),
//              Text(
//                "Status",
//                style: TextStyle(color: Colors.white60, fontSize: 12),
//              )
//            ],
//          )
//        ],
//      ),
//    );
//  }
//}
