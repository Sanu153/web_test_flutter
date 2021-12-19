import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/buySellRequestAdder/custom_number_button.dart';

class MyNumberKeyPad extends StatelessWidget {
  final Function onTap;

  MyNumberKeyPad({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("1");
                  },
                  text: "1",
                )),
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("2");
                  },
                  text: "2",
                )),
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("3");
                  },
                  text: "3",
                )),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("4");
                  },
                  text: "4",
                )),
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("5");
                  },
                  text: "5",
                )),
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("6");
                  },
                  text: "6",
                )),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("7");
                  },
                  text: "7",
                )),
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("8");
                  },
                  text: "8",
                )),
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("9");
                  },
                  text: "9",
                )),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap(".");
                  },
                  text: ".",
                )),
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("0");
                  },
                  text: "0",
                )),
                Expanded(
                    child: MyCustomNumberButton(
                  onPressed: () {
                    onTap("C");
                  },
                  text: "C",
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
