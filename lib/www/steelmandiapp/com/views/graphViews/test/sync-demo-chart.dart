import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DemoChart extends StatefulWidget {
  @override
  _DemoChartState createState() => _DemoChartState();
}

class _DemoChartState extends State<DemoChart> {
  List<AreaSeries<GraphDataPoint, DateTime>> seriesSet;

  List<ProductSpecMarket> productSpecMarketList;

  // Get first GraphPoint Length
  int _length = 0;

  GraphBloc graphBloc;

  @override
  void initState() {
    super.initState();
    _onCreate();
  }

  void _onCreate() {
    seriesSet = getSeries();
    //print("AreaChart DidChangeDependencies Called");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  DateTime getSyncTime(DateTime dateTime) => DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second);

  List<AreaSeries<GraphDataPoint, DateTime>> getSeries() {
    final List<Color> color2 = <Color>[];
    color2.add(Color.fromARGB(73, 2, 0, 34));
    color2.add(Color.fromARGB(90, 50, 118, 205));
    final List<AreaSeries<GraphDataPoint, DateTime>> dataList = [];
    final LinearGradient gradientColor2 = LinearGradient(
        colors: color2,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);

    dataList.add(AreaSeries<GraphDataPoint, DateTime>(
      borderColor: Colors.lightBlueAccent,
      borderWidth: 1.3,
      isVisible: true,
      opacity: 0.7,
      name: "Demo",
      gradient: gradientColor2,
      dataSource: _getDataSource(),
      xValueMapper: (GraphDataPoint graphData, _) => graphData.dateTime,

      yValueMapper: (GraphDataPoint graphData, _) => graphData.price,
      pointColorMapper: (GraphDataPoint data, Color) => Colors.blueAccent,
      dataLabelMapper: (GraphDataPoint data, _) => data.price.toString(),
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

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SfCartesianChart(
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
          enable: true,
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
        series: seriesSet,
        margin: EdgeInsets.only(left: 0, right: 10),
      ),
    );
  }
}

class GraphDataPoint {
  int id;
  DateTime dateTime;
  double price;

  GraphDataPoint({this.id, this.dateTime, this.price});

  GraphDataPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime = DateTime.parse(json['date_time']);
    price = json['price'];
  }
}

List<GraphDataPoint> _getDataSource() {
  final List collection = [
    {"id": -1, "date_time": "2020-07-03T23:07:33.442+05:30", "price": 1235.0},
    {
      "id": 3112754,
      "date_time": "2020-07-02T18:00:00.000+05:30",
      "price": 1235.0
    },
    {
      "id": 3112784,
      "date_time": "2020-07-02T16:01:14.611+05:30",
      "price": 1326.7
    },
    {
      "id": 3112753,
      "date_time": "2020-07-02T16:00:00.000+05:30",
      "price": 1489.0
    },
    {
      "id": 3112752,
      "date_time": "2020-07-02T14:00:00.000+05:30",
      "price": 1533.0
    },
    {
      "id": 3112751,
      "date_time": "2020-07-02T12:00:00.000+05:30",
      "price": 1245.0
    },
    {
      "id": 3112750,
      "date_time": "2020-07-02T10:00:00.000+05:30",
      "price": 1125.0
    },
    {
      "id": 3112749,
      "date_time": "2020-07-02T08:00:00.000+05:30",
      "price": 1050.0
    },
    {
      "id": 3112748,
      "date_time": "2020-07-02T06:00:00.000+05:30",
      "price": 1100.0
    },
    {
      "id": 3112747,
      "date_time": "2020-07-02T04:00:00.000+05:30",
      "price": 1200.0
    },
    {
      "id": 3112746,
      "date_time": "2020-07-02T02:00:00.000+05:30",
      "price": 1150.0
    },
    {
      "id": 3112745,
      "date_time": "2020-07-02T00:00:00.000+05:30",
      "price": 1100.0
    },
    {
      "id": 3112763,
      "date_time": "2020-07-01T18:00:00.000+05:30",
      "price": 1678.0
    },
    {
      "id": 3112762,
      "date_time": "2020-07-01T16:00:00.000+05:30",
      "price": 1589.0
    },
    {
      "id": 3112761,
      "date_time": "2020-07-01T14:00:00.000+05:30",
      "price": 1256.0
    },
    {
      "id": 3112760,
      "date_time": "2020-07-01T12:00:00.000+05:30",
      "price": 1425.0
    },
    {
      "id": 3112759,
      "date_time": "2020-07-01T10:00:00.000+05:30",
      "price": 1532.0
    },
    {
      "id": 3112758,
      "date_time": "2020-07-01T08:00:00.000+05:30",
      "price": 1236.0
    },
    {
      "id": 3112757,
      "date_time": "2020-07-01T06:00:00.000+05:30",
      "price": 1483.0
    },
    {
      "id": 3112756,
      "date_time": "2020-07-01T04:00:00.000+05:30",
      "price": 1256.0
    },
    {
      "id": 3112755,
      "date_time": "2020-07-01T02:00:00.000+05:30",
      "price": 1456.0
    },
    {"id": -2, "date_time": "2020-06-30T23:07:33.439+05:30", "price": 1236.0}
  ];

  return collection.map((json) => GraphDataPoint.fromJson(json)).toList();
}
