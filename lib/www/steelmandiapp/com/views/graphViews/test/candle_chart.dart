import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleChart extends StatefulWidget {
  @override
  _CandleChartState createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  @override
  Widget build(BuildContext context) {
    return getCandle();
  }
}

SfCartesianChart getCandle() {
  return SfCartesianChart(
    plotAreaBorderWidth: 0.0,
    title: ChartTitle(text: "Candle Stick"),
    primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.MMM(),
        interval: 3,
        intervalType: DateTimeIntervalType.months,
        minimum: DateTime(2016, 01, 01),
        maximum: DateTime(2016, 10, 01),
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        minimum: 140,
        maximum: 60,
        interval: 20,
        labelFormat: '\${value}',
        axisLine: AxisLine(width: 0)),
    series: getCandleSeries(),
    trackballBehavior: TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap),
  );
}

List<CandleSeries<ChartSampleData, DateTime>> getCandleSeries() {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2016, 01, 11),
        open: 98.97,
        yValue: 101.19,
        y: 95.36,
        close: 97.13),
    ChartSampleData(
        x: DateTime(2016, 01, 18),
        open: 98.41,
        yValue: 101.46,
        y: 93.42,
        close: 101.42),
    ChartSampleData(
        x: DateTime(2016, 01, 25),
        open: 101.52,
        yValue: 101.53,
        y: 92.39,
        close: 97.34),
    ChartSampleData(
        x: DateTime(2016, 02, 01),
        open: 96.47,
        yValue: 97.33,
        y: 93.69,
        close: 94.02),
    ChartSampleData(
        x: DateTime(2016, 02, 08),
        open: 93.13,
        yValue: 96.35,
        y: 92.59,
        close: 93.99),
    ChartSampleData(
        x: DateTime(2016, 02, 15),
        open: 95.02,
        yValue: 98.89,
        y: 94.61,
        close: 96.04),
    ChartSampleData(
        x: DateTime(2016, 02, 22),
        open: 96.31,
        yValue: 98.0237,
        y: 93.32,
        close: 96.91),
    ChartSampleData(
        x: DateTime(2016, 02, 29),
        open: 96.86,
        yValue: 103.75,
        y: 96.65,
        close: 103.01),
    ChartSampleData(
        x: DateTime(2016, 03, 07),
        open: 102.39,
        yValue: 102.83,
        y: 100.15,
        close: 102.26),
    ChartSampleData(
        x: DateTime(2016, 03, 14),
        open: 101.91,
        yValue: 106.5,
        y: 101.78,
        close: 105.92),
    ChartSampleData(
        x: DateTime(2016, 03, 21),
        open: 105.93,
        yValue: 107.65,
        y: 104.89,
        close: 105.67),
    ChartSampleData(
        x: DateTime(2016, 03, 28),
        open: 106,
        yValue: 110.42,
        y: 104.88,
        close: 109.99),
    ChartSampleData(
        x: DateTime(2016, 04, 04),
        open: 110.42,
        yValue: 112.19,
        y: 108.121,
        close: 108.66),
    ChartSampleData(
        x: DateTime(2016, 04, 11),
        open: 108.97,
        yValue: 112.39,
        y: 108.66,
        close: 109.85),
    ChartSampleData(
        x: DateTime(2016, 04, 18),
        open: 108.89,
        yValue: 108.95,
        y: 104.62,
        close: 105.68),
    ChartSampleData(
        x: DateTime(2016, 04, 25),
        open: 105,
        yValue: 105.65,
        y: 92.51,
        close: 93.74),
    ChartSampleData(
        x: DateTime(2016, 05, 02),
        open: 93.965,
        yValue: 95.9,
        y: 91.85,
        close: 92.72),
    ChartSampleData(
        x: DateTime(2016, 05, 09),
        open: 93,
        yValue: 93.77,
        y: 89.47,
        close: 90.52),
    ChartSampleData(
        x: DateTime(2016, 05, 16),
        open: 92.39,
        yValue: 95.43,
        y: 91.65,
        close: 95.22),
    ChartSampleData(
        x: DateTime(2016, 05, 23),
        open: 95.87,
        yValue: 100.73,
        y: 95.67,
        close: 100.35),
    ChartSampleData(
        x: DateTime(2016, 05, 30),
        open: 99.6,
        yValue: 100.4,
        y: 96.63,
        close: 97.92),
    ChartSampleData(
        x: DateTime(2016, 06, 06),
        open: 97.99,
        yValue: 101.89,
        y: 97.55,
        close: 98.83),
    ChartSampleData(
        x: DateTime(2016, 06, 13),
        open: 98.69,
        yValue: 99.12,
        y: 95.3,
        close: 95.33),
    ChartSampleData(
        x: DateTime(2016, 06, 20),
        open: 96,
        yValue: 96.89,
        y: 92.65,
        close: 93.4),
    ChartSampleData(
        x: DateTime(2016, 06, 27),
        open: 93,
        yValue: 96.465,
        y: 91.5,
        close: 95.89),
    ChartSampleData(
        x: DateTime(2016, 07, 04),
        open: 95.39,
        yValue: 96.89,
        y: 94.37,
        close: 96.68),
    ChartSampleData(
        x: DateTime(2016, 07, 11),
        open: 96.75,
        yValue: 99.3,
        y: 96.73,
        close: 98.78),
    ChartSampleData(
        x: DateTime(2016, 07, 18),
        open: 98.7,
        yValue: 101,
        y: 98.31,
        close: 98.66),
    ChartSampleData(
        x: DateTime(2016, 07, 25),
        open: 98.25,
        yValue: 104.55,
        y: 96.42,
        close: 104.21),
    ChartSampleData(
        x: DateTime(2016, 08, 01),
        open: 104.41,
        yValue: 107.65,
        y: 104,
        close: 107.48),
    ChartSampleData(
        x: DateTime(2016, 08, 08),
        open: 107.52,
        yValue: 108.94,
        y: 107.16,
        close: 108.18),
    ChartSampleData(
        x: DateTime(2016, 08, 15),
        open: 108.14,
        yValue: 110.23,
        y: 108.08,
        close: 109.36),
    ChartSampleData(
        x: DateTime(2016, 08, 22),
        open: 108.86,
        yValue: 109.32,
        y: 106.31,
        close: 106.94),
    ChartSampleData(
        x: DateTime(2016, 08, 29),
        open: 106.62,
        yValue: 108,
        y: 105.5,
        close: 107.73),
    ChartSampleData(
        x: DateTime(2016, 09, 05),
        open: 107.9,
        yValue: 108.76,
        y: 103.13,
        close: 103.13),
    ChartSampleData(
        x: DateTime(2016, 09, 12),
        open: 102.65,
        yValue: 116.13,
        y: 102.53,
        close: 114.92),
    ChartSampleData(
        x: DateTime(2016, 09, 19),
        open: 115.19,
        yValue: 116.18,
        y: 111.55,
        close: 112.71),
    ChartSampleData(
        x: DateTime(2016, 09, 26),
        open: 111.64,
        yValue: 114.64,
        y: 111.55,
        close: 113.05),
  ];
  return <CandleSeries<ChartSampleData, DateTime>>[
    CandleSeries<ChartSampleData, DateTime>(
        enableTooltip: true,
        enableSolidCandles: true,
        dataSource: chartData,
        name: 'AAPL',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        lowValueMapper: (ChartSampleData sales, _) => sales.y,
        highValueMapper: (ChartSampleData sales, _) => sales.yValue,
        openValueMapper: (ChartSampleData sales, _) => sales.open,
        closeValueMapper: (ChartSampleData sales, _) => sales.close,
        dataLabelSettings: DataLabelSettings(isVisible: false))
  ];
}

class ChartSampleData {
  DateTime x;
  double y;
  double yValue;
  double open;
  double close;

  ChartSampleData({this.x, this.y, this.yValue, this.open, this.close});
}
