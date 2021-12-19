import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_graph_data_test.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyLineComparisonChart extends StatefulWidget {
  @override
  _MyColumnGraphState createState () => _MyColumnGraphState();
}

class _MyColumnGraphState extends State<MyLineComparisonChart> {
  @override
  Widget build (BuildContext context) {
    return Container(
      child: SfCartesianChart(
        /// Get X--Y axispoints
        crosshairBehavior: CrosshairBehavior(
            shouldAlwaysShow: true,
            lineType: CrosshairLineType.horizontal,
            enable: true,
            activationMode: ActivationMode.singleTap),
//        enableMultiSelection: true,
//        trackballBehavior: TrackballBehavior(
//            enable: true, activationMode: ActivationMode.singleTap),
        legend: Legend(
          isVisible: true,
          alignment: ChartAlignment.near,
          orientation: LegendItemOrientation.vertical,
          position: LegendPosition.top,
        ),
        primaryXAxis: NumericAxis(
          labelPosition: ChartDataLabelPosition.outside,
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
        ),
        zoomPanBehavior: ZoomPanBehavior(
//            selectionRectColor: Colors.red,
            maximumZoomLevel: 0.8,
            enableDoubleTapZooming: true,
            enablePanning: true,
            enableSelectionZooming: false),
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
          LineSeries<ProductComparison, double>(
            name: "Product One",
            dataSource: getLargeComparisonData(),
            xValueMapper: (ProductComparison data, _) => data.x,
            yValueMapper: (ProductComparison data, _) => data.y1,
            pointColorMapper: (ProductComparison data, Color) =>
            firstGraphLineColor,
          ),
          LineSeries<ProductComparison, double>(
            name: "Product Two",
//            enableTooltip: true,
//            dataLabelSettings: DataLabelSettings(
//                isVisible: true,
//                color: Colors.red,
//                angle: 150,
//                labelPosition: ChartDataLabelPosition.inside,
//                opacity: 0.4,
//                labelAlignment: ChartDataLabelAlignment.bottom,
//                connectorLineSettings:
//                    ConnectorLineSettings(color: Colors.cyan, width: 5),
//                textStyle: ChartTextStyle(color: Colors.yellow)),
//            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomLeft,colors: [Colors.red, Colors.yellow]),
            dataSource: getLargeComparisonData(),
            xValueMapper: (ProductComparison data, _) => data.x,
            yValueMapper: (ProductComparison data, _) => data.y2,
            pointColorMapper: (ProductComparison data, Color) =>
            secondGraphLineColor,
          )
        ],
      ),
    );
  }
}
