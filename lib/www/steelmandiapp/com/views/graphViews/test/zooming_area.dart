import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_spec_market_grapph.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyAreaChart extends StatefulWidget {
  @override
  _MyColumnGraphState createState() => _MyColumnGraphState();
}

class _MyColumnGraphState extends State<MyAreaChart> {
  List<AreaSeries<GraphData, DateTime>> seriesSet;
  ProductBloc _productBloc;
  UserProduct _userProduct;

  @override
  void initState() {
    super.initState();
  }

  void _onCreate() {
    _userProduct = _productBloc.getCurrentUserProduct;
    seriesSet = getSeries();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productBloc = Provider.of(context).fetch(ProductBloc);
    _onCreate();
  }

  List<AreaSeries<GraphData, DateTime>> getSeries() {
    final List<Color> color = <Color>[];
    color.add(Colors.blueGrey[400]);
    color.add(Colors.blueGrey[600]);
    color.add(Colors.blueGrey[700]);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);
    final LinearGradient gradientColors = LinearGradient(colors: color);
    return <AreaSeries<GraphData, DateTime>>[
//      AreaSeries<GraphData, DateTime>(
//        name:
//        "${_userProduct.userGraph.productSpecMarket.first.marketHierarchy
//            .name}",
//        gradient: gradientColors,
//        dataSource: _userProduct.userGraph.productSpecMarket.first.graphData,
//        xValueMapper: (GraphData graphData, _) => graphData.dateTime,
//        yValueMapper: (GraphData graphData, _) => graphData.price,
//        pointColorMapper: (GraphData data, Color) => firstGraphLineColor,
//      ),
    ];
  }

  bool isTileView = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SfCartesianChart(
        legend: Legend(
            isVisible: true,
            alignment: ChartAlignment.near,
            orientation: LegendItemOrientation.vertical,
            position: LegendPosition.top,
            backgroundColor: Colors.white,
            textStyle: ChartTextStyle(
                color: firstGraphLineColor,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        zoomPanBehavior: ZoomPanBehavior(
            enableDoubleTapZooming: true,
            selectionRectBorderColor: Colors.lightBlueAccent,
            selectionRectBorderWidth: 1,
            selectionRectColor: Colors.grey,
            enableSelectionZooming: true,
            enablePinching: true,
            zoomMode: ZoomMode.x,
            enablePanning: true),
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
          majorTickLines: MajorTickLines(size: 0),
          labelPosition: ChartDataLabelPosition.outside,
          interval: 500,
          isVisible: true,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          opposedPosition: true,
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          interactiveTooltip:
          InteractiveTooltip(enable: isTileView ? true : false),
        ),
        series: seriesSet,
      ),
    );
  }
}
