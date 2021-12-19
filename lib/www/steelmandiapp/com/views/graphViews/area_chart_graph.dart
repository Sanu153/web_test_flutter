import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/annotation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_spec_market_grapph.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/user_graph_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/graphViews/annotation/annotation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/graphViews/annotation/buy_sell_annotation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AreaChartGraph extends StatelessWidget {
  final UserGraph graph;

  AreaChartGraph({this.graph});

  // Get first GraphPoint Length
  int _length = 0;

//  GraphBloc graphBloc;

  DateTime getSyncTime(DateTime dateTime) => DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second);

  Color getLineColor(index) => index == 0
      ? Colors.lightBlueAccent
      : index == 1 ? Colors.white : Colors.amber;

  List<AreaSeries<GraphData, DateTime>> getSeries(BuildContext context) {
    final GraphBloc graphBloc = Provider.of(context).fetch(GraphBloc);

    // First Color Set
    final List<Color> color = <Color>[];
    color.add(Colors.blueGrey[300].withOpacity(0.1));
    color.add(Colors.blueGrey[300].withOpacity(0.5));

    // Second Color Set
    final List<Color> color2 = <Color>[];
//    color2.add(Colors.transparent);
//    color2.add(Colors.blue[300].withOpacity(0.1));
    color2.add(Color.fromARGB(73, 2, 0, 34));
    color2.add(Color.fromARGB(90, 50, 118, 205));

    // Third Color Set
    final List<Color> color3 = <Color>[];
    color3.add(Colors.orange[100].withOpacity(0.1));
    color3.add(Colors.orange[300].withOpacity(0.5));

    final List<AreaSeries<GraphData, DateTime>> dataList = [];

    final LinearGradient gradientColor = LinearGradient(
        colors: color, begin: Alignment.topCenter, end: Alignment.bottomCenter);
    final LinearGradient gradientColor2 = LinearGradient(
        colors: color2,
//        stops: [0.2, 1.5],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    final LinearGradient gradientColor3 = LinearGradient(
        colors: color3,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);

    for (int i = 0; i < graph.productSpecMarket.length; i++) {
      final ProductSpecMarket data = graph.productSpecMarket[i];
//      print("Graph Data Length: ${data.graphData.length}");
//      data.graphData
//          .forEach((GraphData d) => print("${d.dateTime} === ${d.price}"));
//      print("Ended---->");

      dataList.add(AreaSeries<GraphData, DateTime>(
        borderColor: getLineColor(i),
        borderWidth: 1.3,
        isVisible: true,
        opacity: 0.7,
        name: "${data.marketHierarchy.name} ",
        gradient:
            i == 0 ? gradientColor2 : i == 1 ? gradientColor : gradientColor3,
        dataSource: data.graphData,
        xValueMapper: (GraphData graphData, _) => graphData.dateTime,

        yValueMapper: (GraphData graphData, _) => graphData.price,
        pointColorMapper: (GraphData data, Color) => firstGraphLineColor,
        dataLabelMapper: (GraphData data, _) => data.price.toString(),
        animationDuration: 0,
        // Marker
        markerSettings: MarkerSettings(
            isVisible: false, shape: DataMarkerType.horizontalLine),
        dataLabelSettings: DataLabelSettings(
            isVisible: false,
            useSeriesColor: true,
            alignment: ChartAlignment.far,
            labelPosition: ChartDataLabelPosition.outside,
            labelAlignment: ChartDataLabelAlignment.outer),
      ));
    }
    return dataList;
  }

  List<CartesianChartAnnotation> getAnnotation(BuildContext context) {
    final GraphBloc graphBloc = Provider.of(context).fetch(GraphBloc);

    final List<CartesianChartAnnotation> _list =
        List<CartesianChartAnnotation>();
//    graphBloc.getAnnotations.forEach((d) => ////print(d));
    for (int i = 0; i < graphBloc.getAnnotations.length; i++) {
      final lastData = graphBloc.getAnnotations[i];

      if (lastData is TradeBuySellRequest) {
        //print("Data For TradeBuySellRequest");
        final annotation = CartesianChartAnnotation(
            widget: MyBuySellAnnotation(
              dateTime: lastData.createdAt,
              hasBuy: lastData.buySell == 'Buy' ? true : false,
              price: lastData.price,
            ),
            coordinateUnit: CoordinateUnit.point,
            region: AnnotationRegion.chart,
            x: lastData.createdAt,
            y: lastData.price);
        _list.add(annotation);
      } else if (lastData is Annotation) {
//        print("Last Date Annotation: ${lastData.dateTime}");
//        print("Last Price Annotation: ${lastData.price}");
        final annotation = CartesianChartAnnotation(
            widget: MyAnnotation(
              data: lastData.price.toString(),
              color: getLineColor(i),
              hasSnakeDot: true,
            ),
            coordinateUnit: CoordinateUnit.point,
            region: AnnotationRegion.chart,
            x: lastData.dateTime,
            y: lastData.price);
        _list.add(annotation);
      }

      ////print("Last Price: ${lastData.price}");
    }
//    // Test Annotation

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    if (graph.productSpecMarket[0].graphData == null) {
      return ResponseFailure(
        title: "No Graph Points Found",
      );
    }
    _length = graph.productSpecMarket[0].graphData.length;

    return Material(
      color: Colors.transparent,
      child: SfCartesianChart(
        annotations: getAnnotation(context),
        // Legend
        legend: Legend(
            isVisible: true,
            alignment: ChartAlignment.near,
            orientation: LegendItemOrientation.horizontal,
            position: LegendPosition.top,
            toggleSeriesVisibility: true,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: ChartTextStyle(color: Colors.white70)),

        // Zooming and Panning
        zoomPanBehavior: ZoomPanBehavior(
            enableDoubleTapZooming: true,
            enablePinching: true,
            zoomMode: ZoomMode.x,
            enablePanning: true),
        plotAreaBorderWidth: 0,

        // Primary AXIS
        primaryXAxis: DateTimeAxis(
//          visibleMinimum: productSpecMarketList[0].graphData[10].dateTime,
//          visibleMaximum:
//              productSpecMarketList[0].graphData[_length - 1].dateTime,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 0.02, dashArray: [0.4, 0.2]),
          axisLine: AxisLine(width: 0),
          rangePadding: ChartRangePadding.none,
//          intervalType: DateTimeIntervalType.seconds,
          dateFormat: DateFormat.Hm(),
          interactiveTooltip: InteractiveTooltip(enable: true),
        ),

        // Tooltip Behaviour
        tooltipBehavior: TooltipBehavior(
            canShowMarker: true,
            enable: true,
            activationMode: ActivationMode.longPress),

        // TrackBall Behaviour
        trackballBehavior: TrackballBehavior(
            // Enables the trackball
            enable: true,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            shouldAlwaysShow: true,
            tooltipSettings: InteractiveTooltip(
                format: "point.y",
                enable: true,
                color: Colors.grey[900],
                arrowLength: 5.0,
                textStyle: ChartTextStyle(
                    fontSize: 12.0, fontWeight: FontWeight.bold))),
        crosshairBehavior: CrosshairBehavior(
          enable: false,
          lineWidth: 1,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: true,
          lineType: CrosshairLineType.both,
        ),
        primaryYAxis: NumericAxis(
          majorTickLines: MajorTickLines(size: 0),
          opposedPosition: true,
          labelPosition: ChartDataLabelPosition.outside,
//          interval: 500,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(width: 0.02, dashArray: [0.4, 0.2]),
          interactiveTooltip: InteractiveTooltip(enable: true),
        ),
        series: getSeries(context),
        margin: EdgeInsets.only(left: 0, right: 10),
//          onActualRangeChanged: (ActualRangeChangedArgs args) {
//            print("ActualRangeChangedArgs Called");
//            if (args.axisName == 'primaryYAxis') {
//              // Configure For Y-Axis
//              args.visibleMin = 100;
//            }
//          }
        //Zoom Start
//          onZoomStart: (ZoomPanArgs args) {
//            print("Zoom Start Factor: ${args.currentZoomFactor}");
//            print(
//                "Zoom Start currentZoomPosition: ${args.currentZoomPosition}");
//          },
      ),
    );
  }
}
