import 'package:flutter/material.dart';

class MyCustomDropDown extends StatelessWidget {
  final String value;
  final Function onChanged;
  final List<Map<String, dynamic>> items;

  const MyCustomDropDown (
      {@required this.value, @required this.onChanged, @required this.items});

  @override
  Widget build (BuildContext context) {
    return Container(
      child: DropdownButton(
        hint: Text("Invest on"),
        value: value,
        onChanged: onChanged,
        items: items.map((Map value) {
          return DropdownMenuItem(
            value: value['id'],
            child: Text(value['name']),
          );
        }).toList(),
      ),
    );
  }
}
