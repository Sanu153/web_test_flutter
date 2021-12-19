import 'package:flutter/material.dart';

class Utility {
  static double _minValue = 8.0;

  static Future<void> dontCallMe({@required BuildContext context,
    String title,
    String content,
    bool willExit = false}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Exit"),
              onPressed: () {
                Navigator.of(context).pop();
//                willExit ? exit(0) : //print("Not true");
              },
            ),
          ],
        );
      },
    );
    return null;
  }

  static void readData() async {}

  static void showSnacks(
      {@required String msg, @required BuildContext context}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  static Future<void> neverSatisfied(
      {@required BuildContext context,
      String title = 'Loading',
      String subtitle = 'Please wait',
      bool dialog = true}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: ListTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: _minValue * 2,
                      right: _minValue,
                      bottom: _minValue * 2),
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 4, top: _minValue * 2, bottom: _minValue * 2),
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
              ],
            ),
          ),
//
        );
      },
    );
  }
}
