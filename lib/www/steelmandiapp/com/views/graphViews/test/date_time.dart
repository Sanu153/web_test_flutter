import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_graph_data_test.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyDateTimeChart extends StatefulWidget {
  @override
  _MyColumnGraphState createState() => _MyColumnGraphState();
}

class _MyColumnGraphState extends State<MyDateTimeChart> {
  List<LineSeries<DateTimeData, DateTime>> getSeries() {
    return <LineSeries<DateTimeData, DateTime>>[
      LineSeries<DateTimeData, DateTime>(
        dataSource: getDatatTimeData(),
        xValueMapper: (DateTimeData sales, _) => sales.year,
        yValueMapper: (DateTimeData sales, _) => sales.y,
        pointColorMapper: (DateTimeData data, Color) => firstGraphLineColor,
      ),
      LineSeries<DateTimeData, DateTime>(
          dataSource: getDatatTimeDataSecond(),
          xValueMapper: (DateTimeData sales, _) => sales.year,
          yValueMapper: (DateTimeData sales, _) => sales.y,
          pointColorMapper: (DateTimeData data, Color) => secondGraphLineColor,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              // Position of the data label
              labelPosition: ChartDataLabelPosition.outside))
    ];
  }

  bool isTileView = true;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interactiveTooltip:
              InteractiveTooltip(enable: (isTileView) ? true : false)),
      crosshairBehavior: CrosshairBehavior(
        enable: true,
        lineWidth: 1,
        activationMode: ActivationMode.singleTap,
        shouldAlwaysShow: isTileView,
        lineColor: Colors.red,
        lineDashArray: <double>[5, 5],
        lineType: CrosshairLineType.vertical,
      ),
      primaryYAxis: NumericAxis(
          labelPosition: ChartDataLabelPosition.outside,
          interval: 65,
          isVisible: true,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          opposedPosition: true,
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          interactiveTooltip:
              InteractiveTooltip(enable: isTileView ? true : false),
          majorTickLines: MajorTickLines(width: 0)),
      series: getSeries(),
    );
  }
}
