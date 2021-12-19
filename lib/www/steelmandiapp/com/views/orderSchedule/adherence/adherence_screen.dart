import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/adherence.dart';

class AdherenceScreen extends StatelessWidget {
  final List<Adherence> adherence;

  AdherenceScreen({this.adherence});

  final headers = <String>[
    "Date",
    "Schedule Payment",
    "Schedule Delivery",
    "Actual Payment",
    "Actual Delivery"
  ];

  Widget _buildHeader() {
    final style = TextStyle(color: Colors.teal[200], fontSize: 13.0);

    return Container(
      height: 55.0,
      child: Row(
        children: headers
            .map<Widget>((e) => Expanded(
                    child: Text(
                  "$e",
                  textAlign: TextAlign.center,
                  style: style,
                )))
            .toList(),
      ),
    );
  }

  Widget _buildTile(Adherence adherence, int index) {
    final style = TextStyle(color: Colors.white70, fontSize: 12.0);

    return Container(
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Text(
            "${adherence.date}",
            textAlign: TextAlign.center,
            style: style,
          )),
          Expanded(
              child: Text(
            "${adherence.scheduledPayment}",
            textAlign: TextAlign.center,
            style: style,
          )),
          Expanded(
              child: Text(
            "${adherence.scheduledDelivery}",
            textAlign: TextAlign.center,
            style: style,
          )),
          Expanded(
              child: Text(
            "${adherence.todaysPayment}",
            textAlign: TextAlign.center,
            style: style,
          )),
          Expanded(
              child: Text(
            "${adherence.todaysDelivery}",
            textAlign: TextAlign.center,
            style: style,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (adherence.length == 0)
        ? Center(
            child: Text("No Data Available"),
          )
        : Column(
            children: <Widget>[
              _buildHeader(),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: adherence.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Adherence _adherence = adherence[index];
                    return _buildTile(_adherence, index);
                  }),
            ],
          );
  }
}
