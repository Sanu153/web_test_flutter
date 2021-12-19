import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LiveUpdateHorizontalData extends StatefulWidget {
  const LiveUpdateHorizontalData({Key key}) : super(key: key);

  @override
  _LiveUpdateHorizontalDataState createState() =>
      _LiveUpdateHorizontalDataState();
}

class _LiveUpdateHorizontalDataState extends State<LiveUpdateHorizontalData> {
  List<OrdinalSales> chartData;
  bool init;
  num y;
  SfCartesianChart chart;
  CrosshairBehavior crosshairBehavior =
      CrosshairBehavior(enable: true, lineType: CrosshairLineType.horizontal);
  TrackballBehavior trackballBehavior =
      TrackballBehavior(enable: true, lineType: TrackballLineType.horizontal);
  int count = 0;

  @override
  void initState() {
    init = true;
    chartData = <OrdinalSales>[
      OrdinalSales(0, 50),
      OrdinalSales(1, 20),
    ];
    super.initState();
  }

  Timer timer;

  @override
  void dispose() {
    super.dispose();
  }

  void showCrossHair(int index) {
    crosshairBehavior.showByIndex(index);
  }

  void showTrackball(int index) {
    trackballBehavior.showByIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    chart = SfCartesianChart(
      primaryXAxis:
          NumericAxis(interactiveTooltip: InteractiveTooltip(enable: false)),

      onDataLabelRender: (DataLabelRenderArgs args) {
//        count >= 0 ? showTrackball(count + 1) : null;
        count > 0 ? showCrossHair(count + 1) : null;
      },
      crosshairBehavior: crosshairBehavior,
      tooltipBehavior: TooltipBehavior(
          canShowMarker: true,
          enable: true,
          activationMode: ActivationMode.longPress),
      // trackballBehavior: trackballBehavior,
      series: <LineSeries<OrdinalSales, int>>[
        LineSeries<OrdinalSales, int>(
            dataSource: chartData,
            xValueMapper: (OrdinalSales sales, _) => sales.country,
            yValueMapper: (OrdinalSales sales, _) => sales.sales,
            animationDuration: 0,
            markerSettings: MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(
                isVisible: true, textStyle: ChartTextStyle(fontSize: 0)))
      ],
    );
    timer = Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        chartData = getChartData();
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Live data update')),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
            child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: chart,
              )
            ],
          ),
        ));
      }),
    );
  }

  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  List<OrdinalSales> getChartData() {
    y = getRandomInt(10, 100);
    chartData.add(OrdinalSales(count, y));

    if (chartData.length == 100) {
      chartData.removeAt(0);
    }

    count = count + 1;

    if (timer != null) {
      timer.cancel();
    }

    return chartData;
  }
}

/// Sample ordinal data type.

class OrdinalSales {
  OrdinalSales(this.country, this.sales);

  final num country;
  final int sales;
}
