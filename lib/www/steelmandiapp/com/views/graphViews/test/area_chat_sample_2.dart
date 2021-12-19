import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

List<ChartData> chartData;

class _ChartPageState extends State<ChartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chartData = getData();
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: SfCartesianChart(
            primaryXAxis: NumericAxis(visibleMinimum: 5, visibleMaximum: 15),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              enableSelectionZooming: true,
            ),
            series: <CartesianSeries<ChartData, double>>[
              LineSeries(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              )
            ],
          ),
        ));
  }
}

dynamic getData() {
  List<ChartData> data = [];
  for (double i = 1; i < 20; i++) {
    data.add(ChartData(i, getRandomInt(10, 100)));
  }
  return data;
}

num getRandomInt(num min, num max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}

class ChartData {
  ChartData(this.x, this.y);

  final double x;
  final int y;
}
