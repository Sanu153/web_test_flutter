import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_spec_market_grapph.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/user_graph_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyLineSeriesInitGraph extends StatefulWidget {
  final UserGraph graph;

  MyLineSeriesInitGraph({this.graph});

  @override
  _MyColumnGraphState createState() => _MyColumnGraphState();
}

class _MyColumnGraphState extends State<MyLineSeriesInitGraph> {
  List<LineSeries<GraphData, DateTime>> seriesSet;

  List<ProductSpecMarket> productSpecMarketList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productSpecMarketList = widget.graph.productSpecMarket;
  }

  void _onCreate() {
    seriesSet = getSeries();
  }

  DateTime getSyncTime(DateTime dateTime) => DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second);

  List<LineSeries<GraphData, DateTime>> getSeries() {
    // First Color Set
    final List<Color> color = <Color>[];
    color.add(Colors.blueGrey[400]);
    color.add(Colors.blueGrey[600]);
    color.add(Colors.blueGrey[700]);

    // Second Color Set

    final List<Color> color2 = <Color>[];
    color2.add(firstGraphLineColor);
//    color2.add(Colors.amber[300]);
//    color2.add(Colors.amber[200]);

    // Third Color Set

    final List<Color> color3 = <Color>[];
    color3.add(secondGraphLineColor);
    final LinearGradient gradientColor = LinearGradient(colors: color);

    final List<LineSeries<GraphData, DateTime>> dataList = [];

    for (int i = 0; i < productSpecMarketList.length; i++) {
      final ProductSpecMarket data = productSpecMarketList[i];

      dataList.add(LineSeries<GraphData, DateTime>(
//        gradient: gradientColor,
        opacity: i == 0 ? 1.0 : 0.6,
        name: "${data.marketHierarchy.name}",
        dataSource: data.graphData,
        xValueMapper: (GraphData graphData, _) => graphData.dateTime,
        yValueMapper: (GraphData graphData, _) => graphData.price,
        pointColorMapper: (GraphData data, Color) =>
            i == 0 ? firstGraphLineColor : secondGraphLineColor,
      ));
    }
    return dataList;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _onCreate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        /// Get X--Y axispoints
//        crosshairBehavior: CrosshairBehavior(
//            enable: true, activationMode: ActivationMode.singleTap),
//        enableMultiSelection: true,
//        trackballBehavior: TrackballBehavior(
//            enable: true, activationMode: ActivationMode.singleTap),

        primaryXAxis: DateTimeAxis(
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
//            interval: 4500,
            dateFormat: DateFormat('MMM-dd'),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            interactiveTooltip: InteractiveTooltip(enable: true)),
        legend: Legend(
            isVisible: true,
            alignment: ChartAlignment.near,
            orientation: LegendItemOrientation.vertical,
            position: LegendPosition.top,
            textStyle: ChartTextStyle(
              color: Colors.white,
              fontSize: 14.0,
            )),
        zoomPanBehavior: ZoomPanBehavior(
            enableDoubleTapZooming: true,
//            selectionRectBorderColor: Colors.lightBlueAccent,
//            selectionRectBorderWidth: 1,
//            selectionRectColor: Colors.grey,
//            enableSelectionZooming: true,
            enablePinching: true,
            zoomMode: ZoomMode.xy,
            enablePanning: true),
        plotAreaBorderColor: Colors.transparent,
        primaryYAxis: NumericAxis(
          majorTickLines: MajorTickLines(size: 0),
          labelPosition: ChartDataLabelPosition.outside,
          interval: 2000,
          isVisible: true,
//          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          opposedPosition: true,
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          interactiveTooltip: InteractiveTooltip(enable: true),
          associatedAxisName: "dhdj",
          labelFormat: "{value}",
        ),
        tooltipBehavior: TooltipBehavior(
            enable: true, activationMode: ActivationMode.longPress),
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            lineColor: Colors.red,
            tooltipSettings: InteractiveTooltip(format: 'point.x:point.y')),
        annotations: <CartesianChartAnnotation>[
          CartesianChartAnnotation(
              widget: Container(
                  child: Text(
                    productSpecMarketList[productSpecMarketList.length - 1]
                        .maxPrice
                        .toString(),
                  )),
              coordinateUnit: CoordinateUnit.logicalPixel,
              region: AnnotationRegion.plotArea,
              x: 300,
              y: 20),
        ],
        // Other configurations

        series: seriesSet,
      ),
    );
  }
}
