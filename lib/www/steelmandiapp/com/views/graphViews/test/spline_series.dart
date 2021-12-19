import 'dart:async';

import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_graph_data_test.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MySplineSeriesInitGraph extends StatefulWidget {
  @override
  _MyColumnGraphState createState() => _MyColumnGraphState();
}

class _MyColumnGraphState extends State<MySplineSeriesInitGraph> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 900), () {
      setState(() {
        getLiveData();
      });
    });
    return Container(
      child: SfCartesianChart(
        /// Get X--Y axispoints
//        crosshairBehavior: CrosshairBehavior(
//            enable: true, activationMode: ActivationMode.singleTap),
//        enableMultiSelection: true,
        trackballBehavior: TrackballBehavior(
            enable: true, activationMode: ActivationMode.singleTap),
        primaryXAxis: NumericAxis(
          labelPosition: ChartDataLabelPosition.outside,
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
        ),
        zoomPanBehavior: ZoomPanBehavior(
            enableDoubleTapZooming: true,
            enablePanning: true,
            enableSelectionZooming: true),
        plotAreaBorderColor: Colors.transparent,
        primaryYAxis: NumericAxis(
            labelPosition: ChartDataLabelPosition.outside,
            associatedAxisName: "dhdj",
            labelFormat: "{value} K",
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0)),
        tooltipBehavior: TooltipBehavior(
            enable: true, activationMode: ActivationMode.longPress),
        series: <ChartSeries>[
          LineSeries<ProductGraphData, double>(
            dataSource: liveData,
            xValueMapper: (ProductGraphData data, _) => data.x,
            yValueMapper: (ProductGraphData data, _) => data.y,
            pointColorMapper: (ProductGraphData data, Color) => Colors.yellow,
          )
        ],
      ),
    );
  }
}
