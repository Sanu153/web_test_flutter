import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/buySellRequestAdder/custom_number_button.dart';

class MyNegotiateNumberKeyPad extends StatelessWidget {
  final Function onDataChanged;
  final Function increment;
  final Function decrement;
  final Function onClose;

  double minValue = 8.0;

  double finalResult = 0;

  double incDecWidth = 70.0;

  MyNegotiateNumberKeyPad(
      {this.onDataChanged, this.increment, this.decrement, this.onClose});

  Widget _buildActiveCursor() {
    return SpinKitPumpingHeart(
      duration: Duration(seconds: 1),
      size: 45.0,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: minValue),
          color: Colors.white60,
          height: 18.0,
          width: 2.0,
        );
      },
    );
  }

  Widget _buildNumberKeys() {
    return Container(
      margin: EdgeInsets.all(minValue),
      decoration: BoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(minValue * 2)),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("1");
                    },
                    text: "1",
                  )),
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("2");
                    },
                    text: "2",
                  )),
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("3");
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
                      onDataChanged("4");
                    },
                    text: "4",
                  )),
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("5");
                    },
                    text: "5",
                  )),
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("6");
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
                      onDataChanged("7");
                    },
                    text: "7",
                  )),
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("8");
                    },
                    text: "8",
                  )),
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("9");
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
                      onDataChanged(".");
                    },
                    text: ".",
                  )),
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("0");
                    },
                    text: "0",
                  )),
                  Expanded(
                      child: MyCustomNumberButton(
                    onPressed: () {
                      onDataChanged("C");
                    },
                    text: "C",
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIncreDecre(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Material(
              color: Colors.transparent,
              child: SizedBox(
                  width: double.maxFinite,
                  height: 55,
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: increment,
                    elevation: 0.0,
                    backgroundColor: Theme.of(context).primaryColor,
                  ))),
          SizedBox(
            width: double.maxFinite,
            height: 55,
            child: Material(
              color: Colors.transparent,
              child: FloatingActionButton(
                child: Icon(Icons.remove),
                onPressed: decrement,
                elevation: 0.0,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 40,
            child: Material(
              color: Colors.transparent,
              child: FlatButton(
                child: Text(
                  "CLOSE",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: onClose,
//                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Expanded(flex: 2, child: _buildNumberKeys()),
          Expanded(flex: 1, child: _buildIncreDecre(context)),
        ],
      ),
    );
  }
}
