import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_charts/charts.dart';

class DateTimeZooming extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

List<ChartData> chartData;

class _ChartPageState extends State<DateTimeZooming> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
                interval: 1,
                dateFormat: DateFormat.y(),
                visibleMinimum: DateTime(2005, 01, 01),
                visibleMaximum: DateTime(2015, 01, 01)),
            zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true, enableSelectionZooming: true),
            series: <CartesianSeries<ChartData, DateTime>>[
              AreaSeries(
                color: Colors.blue,
                opacity: 0.3,
                dataSource: [
                  ChartData(DateTime(2000, 0, 1), 65),
                  ChartData(DateTime(2001, 0, 1), 55),
                  ChartData(DateTime(2002, 0, 1), 45),
                  ChartData(DateTime(2003, 0, 1), 35),
                  ChartData(DateTime(2004, 0, 1), 25),
                  ChartData(DateTime(2005, 0, 1), 15),
                  ChartData(DateTime(2006, 0, 1), 25),
                  ChartData(DateTime(2007, 0, 1), 35),
                  ChartData(DateTime(2008, 0, 1), 45),
                  ChartData(DateTime(2009, 0, 1), 55),
                  ChartData(DateTime(2010, 0, 1), 65),
                  ChartData(DateTime(2011, 0, 1), 75),
                  ChartData(DateTime(2012, 0, 1), 85),
                  ChartData(DateTime(2013, 0, 1), 75),
                  ChartData(DateTime(2014, 0, 1), 65),
                  ChartData(DateTime(2015, 0, 1), 55),
                  ChartData(DateTime(2016, 0, 1), 45),
                  ChartData(DateTime(2017, 0, 1), 35),
                  ChartData(DateTime(2018, 0, 1), 25),
                  ChartData(DateTime(2019, 0, 1), 15),
                  ChartData(DateTime(2020, 0, 1), 25),
                ],
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              )
            ],
          ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final DateTime x;
  final int y;
}
