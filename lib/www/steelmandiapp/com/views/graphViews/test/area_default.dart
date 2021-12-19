import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AreaDefault extends StatefulWidget {
  @override
  _AreaDefaultState createState() => _AreaDefaultState();
}

class _AreaDefaultState extends State<AreaDefault> {
  @override
  Widget build(BuildContext context) {
    return getDefaultAreaChart();
  }
}

SfCartesianChart getDefaultAreaChart() {
  return SfCartesianChart(
    legend: Legend(isVisible: true, opacity: 0.7),
    title: ChartTitle(text: 'Average sales comparison'),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.y(),
        interval: 1,
        intervalType: DateTimeIntervalType.years,
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}M',
        title: AxisTitle(text: 'Revenue in millions'),
        interval: 1,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getDefaultAreaSeries(),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<AreaSeries<ChartSampleData, DateTime>> getDefaultAreaSeries() {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(2000, 1, 1), y: 4, yValue2: 2.6),
    ChartSampleData(x: DateTime(2001, 1, 1), y: 3.0, yValue2: 2.8),
    ChartSampleData(x: DateTime(2002, 1, 1), y: 3.8, yValue2: 2.6),
    ChartSampleData(x: DateTime(2003, 1, 1), y: 3.4, yValue2: 3),
    ChartSampleData(x: DateTime(2004, 1, 1), y: 3.2, yValue2: 3.6),
    ChartSampleData(x: DateTime(2005, 1, 1), y: 3.9, yValue2: 3),
  ];
  return <AreaSeries<ChartSampleData, DateTime>>[
    AreaSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      opacity: 0.2,
      borderWidth: 2,
      borderColor: Colors.white,
      name: 'Product A',
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
    AreaSeries<ChartSampleData, DateTime>(
      dataSource: chartData,
      opacity: 0.7,
      name: 'Product B',
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
    )
  ];
}

class ChartSampleData {
  final DateTime x;
  final double y;
  final double yValue2;

  ChartSampleData({this.x, this.y, this.yValue2});
}
