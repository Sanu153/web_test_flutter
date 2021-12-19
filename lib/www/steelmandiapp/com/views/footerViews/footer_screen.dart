import 'package:flutter/material.dart';

class MyFooterScreen extends StatefulWidget {
  @override
  _MyFooterScreenState createState() => _MyFooterScreenState();
}

class _MyFooterScreenState extends State<MyFooterScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      child: Text("Footer"),
    );
  }
}
