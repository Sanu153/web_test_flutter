import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/contract.dart';

class ContractTile extends StatelessWidget {
  final Function onTap;
  final Contract contract;

  ContractTile({this.onTap, this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text("Contract No: ${contract.contractId}",
            style: TextStyle(color: Colors.white)),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                "${contract.partyName ?? ''}",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(
                    "${contract.partyType ?? ''}",
                    style: TextStyle(
                        color: contract.partyType != null &&
                                contract.partyType == 'Buyer'
                            ? greenColor
                            : redColor),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  contract.partyType != null && contract.partyType == 'Buyer'
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
            ),
          ],
        ),
        onTap: onTap,
        trailing: Container(
          padding: EdgeInsets.all(4),
          decoration: contract.status != null
              ? BoxDecoration(
            color: contract.status == "Active" ? greenColor : redColor,
            borderRadius: BorderRadius.circular(15.0),
          )
              : null,
          child: Text(
            "${contract.status ?? ''}",
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
