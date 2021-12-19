import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        "assets/image/SM_logo.png",
        width: 250,
      ),
    );
  }
}
