import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/number_key_pad.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_spec_market_grapph.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/custom_circular_border_btn.dart';

class MyCustomNumberKeyPad extends StatefulWidget {
  final String title;
  final String data;
  final Function onFinished;
  final bool hasLiveUpdate;

  MyCustomNumberKeyPad(
      {@required this.title,
      this.data = '',
      @required this.onFinished,
      this.hasLiveUpdate = false});

  @override
  _MyCustomNumberKeyPadState createState() => _MyCustomNumberKeyPadState();
}

class _MyCustomNumberKeyPadState extends State<MyCustomNumberKeyPad> {
  double minValue = 8.0;

  String _result = '';
  double finalResult = 0;

  double incDecWidth = 70.0;

  // HasLiveData=> If Price Is Streaming and User needs to Update Price manually
  // Therefore HasLiveData needs to false To Stop Streaming....
  bool _hasLiveUpdate = false;

  @override
  void initState() {
    super.initState();
    _hasLiveUpdate = widget.hasLiveUpdate;
    _result = widget.data == '0.0' ? '0' : widget.data;
    finalResult = widget.data.isEmpty ? 0 : double.parse(widget.data);
  }

  void _increment() {
    double _ = _result.isEmpty ? 0 : double.parse(_result);
    setState(() {
      _hasLiveUpdate = false;
      _ += 1;
      _result = _.toStringAsFixed(0);
      finalResult = _;
    });
  }

  void _decrement() {
    if (_result.isEmpty || _result == "0") return;
    double _ = _result.isEmpty ? 0 : double.parse(_result);
    setState(() {
      _hasLiveUpdate = false;
      _ -= 1;
      _result = _.toStringAsFixed(0);
      finalResult = _;
    });
  }

  void _resetResult() {
    setState(() {
      _hasLiveUpdate = false;
      _result = '';
      finalResult = 0;
    });
  }

  void _resultHandler(String text) {
    try {
      _hasLiveUpdate = false;

      if (_result.contains(".") && text == ".") return;
      if (text == "C") {
        _resetResult();
        return;
      }

      setState(() {
//        if (text == '0') {
//          text = '0.0';
//        }
        _result = _result + text;
        finalResult = double.parse(_result);
      });
    } catch (e) {
      //print("Error In Parseing: $e");
      _resetResult();
    }
  }

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

  Widget _buildResultHeader() {
    final t = Theme.of(context).textTheme.subhead;
    final sub = Theme.of(context).textTheme.subtitle;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "${widget.title}",
            style: sub.apply(color: buySellTextColor, fontWeightDelta: 1),
            textAlign: TextAlign.center,
          ),
//
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _result.isEmpty
                  ? Text(
                      "Please enter",
                      style: TextStyle(fontSize: 13.0, color: Colors.white24),
                    )
                  : Flexible(
                      child: Text(
                        "$_result",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: t.apply(color: Colors.white, fontWeightDelta: 1),
                      ),
                    ),
              _buildActiveCursor()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: incDecWidth,
                height: 40,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                          minValue,
                        ),
                        bottomRight: Radius.circular(minValue))),
                child: MyCustomCircleIconButton(
                  onPressed: () {
                    _decrement();
                  },
                  icon: Icons.remove,
                ),
              ),
              Expanded(
                child: IconButton(
                    iconSize: 18.0,
                    icon: Icon(
                      _result.isEmpty ? Icons.close : Icons.done,
                      color: iconColor,
                    ),
                    onPressed: () {
                      widget.onFinished(finalResult);
                      Navigator.of(context).pop();
                    }),
              ),
              Container(
                width: incDecWidth,
                height: 40,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          minValue,
                        ),
                        bottomLeft: Radius.circular(minValue))),
                child: MyCustomCircleIconButton(
                  onPressed: () {
                    _increment();
                  },
                  icon: Icons.add,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveResultHeader(String result) {
    final t = Theme.of(context).textTheme.subhead;
    final sub = Theme.of(context).textTheme.subtitle;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "${widget.title}",
            style: sub.apply(color: buySellTextColor, fontWeightDelta: 1),
            textAlign: TextAlign.center,
          ),
//
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              result.isEmpty
                  ? Text(
                      "Please enter",
                      style: TextStyle(fontSize: 13.0, color: Colors.white24),
                    )
                  : Flexible(
                      child: Text(
                        "$result",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: t.apply(color: Colors.white, fontWeightDelta: 1),
                      ),
                    ),
              _buildActiveCursor()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: incDecWidth,
                height: 40,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                          minValue,
                        ),
                        bottomRight: Radius.circular(minValue))),
                child: MyCustomCircleIconButton(
                  onPressed: () {
                    _decrement();
                  },
                  icon: Icons.remove,
                ),
              ),
              Expanded(
                child: IconButton(
                    iconSize: 18.0,
                    icon: Icon(
                      result.isEmpty ? Icons.close : Icons.done,
                      color: iconColor,
                    ),
                    onPressed: () {
                      widget.onFinished(finalResult);
                      Navigator.of(context).pop();
                    }),
              ),
              Container(
                width: incDecWidth,
                height: 40,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          minValue,
                        ),
                        bottomLeft: Radius.circular(minValue))),
                child: MyCustomCircleIconButton(
                  onPressed: () {
                    _increment();
                  },
                  icon: Icons.add,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GraphBloc _graphBloc = Provider.of(context).fetch(GraphBloc);

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: _hasLiveUpdate
                  ? StreamBuilder<GraphData>(
                      stream: _graphBloc.currentSelectedMarketGraph$,
                      builder: (context, AsyncSnapshot snapshot) {
                        //print("Live Price Updating...");
                        if (!snapshot.hasData)
                          return _buildLiveResultHeader('');

                        GraphData lastData = snapshot.data;
                        _result = lastData.price.toString();
                        finalResult = double.parse(_result);
                        return _buildLiveResultHeader(
                            lastData.price.toString());
                      },
                    )
                  : _buildResultHeader()),
          Expanded(
              flex: 3,
              child: MyNumberKeyPad(
                onTap: _resultHandler,
              ))
        ],
      ),
    );
  }
}
