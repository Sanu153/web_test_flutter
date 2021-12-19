import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';

class MyTextFieldViews extends StatefulWidget {
  final Function onSave;
  final Function onChanged;
  final String title;

  MyTextFieldViews({this.onSave, this.onChanged, this.title});

  @override
  _MyTextFieldViewsState createState() => _MyTextFieldViewsState();
}

class _MyTextFieldViewsState extends State<MyTextFieldViews> {
  final TextEditingController _editingController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final double minValue = 8.0;

  @override
  Widget build(BuildContext context) {
    SystemConfig.makeDeviceLandscape();
    SystemConfig.makeStatusBarVisible();
    TextStyle subhead = Theme.of(context).textTheme.title;
    return SafeArea(
      top: false,
      right: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.title ?? 'Message'}"),
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
                widget.onSave(_editingController.text);
              },
              icon: Icon(
                Icons.send,
                size: minValue * 4,
              ),
            ),
            SizedBox(
              width: minValue,
            )
          ],
        ),
        body: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: minValue * 2),
                        color: Colors.grey[300],
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: TextField(
                              controller: _editingController,
                              style: TextStyle(fontSize: 18.0),
                              onChanged: (String value) {
                                if (widget.onChanged != null) {
                                  widget.onChanged(value);
                                }
                              },
                              cursorWidth: 3,
                              cursorRadius: Radius.circular(5),

                              minLines: 2,
                              maxLines: 5,
                              keyboardType: TextInputType.emailAddress,
//                            validator: validateEmail,
                              autofocus: true,
                              decoration: InputDecoration(
//              prefixIcon: Icon(Icons.person),
                                hintText: "Type your message",
                                labelStyle: subhead,
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18.6,
                                ),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(2)),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
//              Align(
//                  alignment: Alignment.centerRight,
//                  child: FloatingActionButton(
//                    backgroundColor: chatTileOne,
//                    onPressed: () => null,
//                    child: Icon(
//                      Icons.send,
//                      size: minValue * 4,
//                    ),
//                  ))
            ],
          ),
        ),
      ),
    );
  }
}
