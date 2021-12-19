import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_graph_data_test.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyColumnGraph extends StatefulWidget {
  @override
  _MyColumnGraphState createState() => _MyColumnGraphState();
}

class _MyColumnGraphState extends State<MyColumnGraph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
            labelPosition: ChartDataLabelPosition.outside,
            majorGridLines: MajorGridLines(width: 0),
            //Hide the axis line of y-axis
            axisLine: AxisLine(width: 0)
//            title: AxisTitle(
//              text: "Date In time",
//            )
            ),
        primaryYAxis: NumericAxis(
            labelPosition: ChartDataLabelPosition.outside,
            associatedAxisName: "dhdj",
            labelFormat: "{value} K",
            majorGridLines: MajorGridLines(width: 0),
            //Hide the axis line of y-axis
            axisLine: AxisLine(width: 0)),
        tooltipBehavior: TooltipBehavior(
            enable: true, activationMode: ActivationMode.longPress),
        series: <ChartSeries>[
          ColumnSeries<ProductGraphData, double>(
              dataSource: getColumnData(),
              xValueMapper: (ProductGraphData data, _) => data.x,
              yValueMapper: (ProductGraphData data, _) => data.y,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  color: Colors.white,
                  labelPosition: ChartDataLabelPosition.inside))
        ],
      ),
    );
  }
}
