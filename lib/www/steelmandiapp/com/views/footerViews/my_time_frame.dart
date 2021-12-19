import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/tim_frame.dart';

class MyTimeFrame extends StatelessWidget {
  final double _minValue = 8.0;

  Widget _buildRaisedBtn(Icon icon, Color color, Function onPressed) {}
  final Color btnTextColor = Colors.grey[400];

  ProductBloc productBloc;

  bool getFrameColor(ProductSpec spec, TimeFrame timeframe) {
    return spec.defaultTimeFrame.id == timeframe.id;
  }

  Widget _buildHardcode(BuildContext context) {
    final Color btnTextColor = iconColor;

    final tStyle =
        Theme.of(context).textTheme.caption.apply(color: btnTextColor);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: RaisedButton(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(3),
              child: Container(
                  height: double.infinity,
                  child: Text(
                    "1M",
                    style: tStyle,
                  )),
              onPressed: () {}),
        ),
        Flexible(
          child: RaisedButton(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(3),
              child: Container(
                  height: double.infinity,
                  child: Text(
                    "1W",
                    style: tStyle,
                  )),
              onPressed: () {}),
        ),
        Flexible(
          child: RaisedButton(
              color: Theme.of(context).secondaryHeaderColor,
              padding: EdgeInsets.all(3),
              child: Container(
                  height: double.infinity,
                  child: Text(
                    "1D",
                    style: tStyle.apply(color: Colors.white),
                  )),
              onPressed: () {}),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    productBloc = Provider.of(context).fetch(ProductBloc);
    final tStyle =
        Theme.of(context).textTheme.caption.apply(color: btnTextColor);
    final GraphBloc _graphBloc = Provider.of(context).fetch(GraphBloc);

    return StreamBuilder<Product>(
        stream: productBloc.currentSelectedProduct$,
        builder: (context, snapshot) {
//          //print("Bottom Stream Time Frame: ${snapshot.data}");
          if (snapshot.data == null || !snapshot.hasData)
            return Text(
              'Loading...',
              style: TextStyle(color: Colors.white70, fontSize: 15.0),
            );
          ProductSpec _productSpec = snapshot.data.productSpecs[0];

//          return ListView.builder(
//              scrollDirection: Axis.horizontal,
//              reverse: true,
//              itemBuilder: (_, index) {
//                //print("Index: $index");
//                final TimeFrame timeFrame = _productSpec.timeFrame[index];
//                return RaisedButton(
//                    color: getFrameColor(_productSpec, timeFrame)
//                        ? Colors.blueGrey[800]
//                        : Theme.of(context).primaryColor,
//                    padding: EdgeInsets.all(_minValue - 3),
//                    child: Container(
//                        height: double.infinity,
//                        child: Text(
//                          timeFrame.shortTimeFrame.toUpperCase(),
//                          style: tStyle,
//                        )),
//                    onPressed: () {});
//              });
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _productSpec.timeFrame
                .map(
                  (timeFrame) => Flexible(
                    child: RaisedButton(
                        color: getFrameColor(_productSpec, timeFrame)
                            ? Colors.blueGrey[800]
                            : Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(_minValue - 3),
                        child: Container(
                            height: double.infinity,
                            child: Text(
                              timeFrame.shortTimeFrame.toUpperCase(),
                              style: tStyle,
                            )),
                        onPressed: () {
                          productBloc.changeDefaultTimeFrame(timeFrame);
                          _graphBloc.switchTimeFrameInterval(timeFrame.id);

                          Scaffold.of(context).showSnackBar(SnackBar(
                            elevation: 0.0,
                            behavior: SnackBarBehavior.floating,
                            content: Container(
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(right: 150),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border:
                                    Border.all(width: 2.0, color: primaryColor),
                              ),
                              child: Text(
                                'Updating Graph ...',
                                style: TextStyle(color: greenColor),
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            duration: Duration(milliseconds: 800),
                          ));
                        }),
                  ),
                )
                .toList(),
          );
        });
  }
}
