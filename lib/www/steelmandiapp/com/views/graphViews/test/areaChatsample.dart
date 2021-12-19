import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MySampleAreChart extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MySampleAreChart> {
  List<PointOfSale> chartData;
  List<CartesianChartAnnotation> chartAnnotation = [];
  Color annotationColor = Colors.lightBlue;
  String annotationText = 'Text';
  int count = 0;

  @override
  void initState() {
    chartData = getConvertedPoints();
    addAnnotation();
    super.initState();
  }

  Timer timer;

  @override
  void dispose() {
    super.dispose();
  }

  void addAnnotation() {
    //print("Anotation Called");
    count += 1;
    if (count > 15) {
      chartAnnotation = [];
      count = 0;
    }
    final PointOfSale sale = chartData[chartData.length - 1];
    setState(() {
      chartAnnotation.add(CartesianChartAnnotation(
          widget: Container(
              child: Container(
                  height: 10 + count.toDouble(),
                  width: 10 + count.toDouble(),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(getRandomInt(10, 200),
                        getRandomInt(1, 230), getRandomInt(10, 200), 1),
                  ),
                  child: Text(annotationText + count.toString()))),
          coordinateUnit: CoordinateUnit.point,
          region: AnnotationRegion.chart,
          x: sale.datetime,
          y: sale.price));
    });
  }

  List<CartesianChartAnnotation> get annotation {
    //print("Length: ${chartAnnotation.length}");
    return chartAnnotation;
  }

  @override
  Widget build(BuildContext context) {
//    Timer(Duration(milliseconds: 2000), () {
//      addAnnotation();
//    });
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Container(
            child: SfCartesianChart(
          annotations: annotation,
          zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enableDoubleTapZooming: true),
          primaryXAxis: DateTimeAxis(
              visibleMaximum: chartData[chartData.length - 1].datetime,
              visibleMinimum: chartData[12].datetime),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <AreaSeries<PointOfSale, DateTime>>[
            AreaSeries<PointOfSale, DateTime>(
              dataSource: chartData,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (PointOfSale sales, _) => sales.datetime,
              yValueMapper: (PointOfSale sales, _) => sales.price,
              animationDuration: 0,
            )
          ],
        )),
      ),
    ));
  }

  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }
}

class PointOfSale {
  DateTime datetime;
  double price;
  int id;

  PointOfSale({this.id, this.datetime, this.price});

  PointOfSale.fromJson(Map<String, dynamic> json) {
    this.price = json['price'];
    this.datetime = DateTime.parse(json['date_time']);
    this.id = json['id'];
  }
}

List<PointOfSale> getConvertedPoints() {
  return dataPoints
      .map((Map<String, dynamic> json) => PointOfSale.fromJson(json))
      .toList();
}

final List<Map<String, dynamic>> dataPoints = [
  {
    "id": 1948264,
    "date_time": "2020-03-03T15:40:03.592+05:30",
    "price": 5725.75
  },
  {
    "id": 1948902,
    "date_time": "2020-03-03T16:09:03.907+05:30",
    "price": 5891.6
  },
  {
    "id": 1949529,
    "date_time": "2020-03-03T16:37:33.875+05:30",
    "price": 5970.06
  },
  {
    "id": 1950167,
    "date_time": "2020-03-03T17:06:34.251+05:30",
    "price": 5796.05
  },
  {
    "id": 1950805,
    "date_time": "2020-03-03T17:35:34.220+05:30",
    "price": 5688.57
  },
  {
    "id": 1951432,
    "date_time": "2020-03-03T18:04:04.388+05:30",
    "price": 5874.78
  },
  {
    "id": 1952070,
    "date_time": "2020-03-03T18:33:04.131+05:30",
    "price": 6033.92
  },
  {
    "id": 1952697,
    "date_time": "2020-03-03T19:01:33.852+05:30",
    "price": 5840.09
  },
  {
    "id": 1953335,
    "date_time": "2020-03-03T19:30:34.233+05:30",
    "price": 5681.49
  },
  {
    "id": 1953973,
    "date_time": "2020-03-03T19:59:33.637+05:30",
    "price": 5842.19
  },
  {
    "id": 1954600,
    "date_time": "2020-03-03T20:28:03.702+05:30",
    "price": 6018.07
  },
  {
    "id": 1955238,
    "date_time": "2020-03-03T20:57:04.279+05:30",
    "price": 5875.32
  },
  {
    "id": 1955865,
    "date_time": "2020-03-03T21:25:33.918+05:30",
    "price": 5694.94
  },
  {
    "id": 1956503,
    "date_time": "2020-03-03T21:54:33.938+05:30",
    "price": 5833.3
  },
  {
    "id": 1957141,
    "date_time": "2020-03-03T22:23:34.010+05:30",
    "price": 6011.2
  },
  {
    "id": 1957768,
    "date_time": "2020-03-03T22:52:04.054+05:30",
    "price": 5930.44
  },
  {
    "id": 1958406,
    "date_time": "2020-03-03T23:21:03.837+05:30",
    "price": 5758.72
  },
  {
    "id": 1959033,
    "date_time": "2020-03-03T23:49:34.187+05:30",
    "price": 5812.2
  },
  {
    "id": 1959671,
    "date_time": "2020-03-04T00:18:34.297+05:30",
    "price": 5981.64
  },
  {
    "id": 1960309,
    "date_time": "2020-03-04T00:47:33.551+05:30",
    "price": 5959.5
  },
  {
    "id": 1960936,
    "date_time": "2020-03-04T01:16:04.419+05:30",
    "price": 5775.11
  },
  {
    "id": 1961574,
    "date_time": "2020-03-04T01:45:04.357+05:30",
    "price": 5788.05
  },
  {
    "id": 1962201,
    "date_time": "2020-03-04T02:13:33.807+05:30",
    "price": 5946.61
  },
  {
    "id": 1962839,
    "date_time": "2020-03-04T02:42:33.776+05:30",
    "price": 5976.5
  },
  {
    "id": 1963477,
    "date_time": "2020-03-04T03:11:33.812+05:30",
    "price": 5804.36
  },
  {
    "id": 1964104,
    "date_time": "2020-03-04T03:40:04.146+05:30",
    "price": 5758.3
  },
  {
    "id": 1964742,
    "date_time": "2020-03-04T04:09:03.947+05:30",
    "price": 5910.77
  },
  {
    "id": 1965369,
    "date_time": "2020-03-04T04:37:33.525+05:30",
    "price": 6041.58
  },
  {
    "id": 1966007,
    "date_time": "2020-03-04T05:06:34.462+05:30",
    "price": 6041.58
  },
  {
    "id": 1966645,
    "date_time": "2020-03-04T05:35:33.590+05:30",
    "price": 6074.48
  },
  {
    "id": 1967272,
    "date_time": "2020-03-04T06:04:04.451+05:30",
    "price": 6234.45
  },
  {
    "id": 1967910,
    "date_time": "2020-03-04T06:33:03.972+05:30",
    "price": 6364.45
  },
  {
    "id": 1968537,
    "date_time": "2020-03-04T07:01:33.885+05:30",
    "price": 6186.0
  },
  {
    "id": 1969175,
    "date_time": "2020-03-04T07:30:33.984+05:30",
    "price": 6027.63
  },
  {
    "id": 1969813,
    "date_time": "2020-03-04T07:59:34.089+05:30",
    "price": 6192.18
  },
  {
    "id": 1970440,
    "date_time": "2020-03-04T08:28:04.328+05:30",
    "price": 6351.13
  },
  {
    "id": 1971078,
    "date_time": "2020-03-04T08:57:03.834+05:30",
    "price": 6200.24
  },
  {
    "id": 1971705,
    "date_time": "2020-03-04T09:25:34.006+05:30",
    "price": 6027.9
  },
  {
    "id": 1972343,
    "date_time": "2020-03-04T09:54:34.037+05:30",
    "price": 6136.3
  },
  {
    "id": 1972981,
    "date_time": "2020-03-04T10:23:34.044+05:30",
    "price": 6321.65
  },
  {
    "id": 1973608,
    "date_time": "2020-03-04T10:52:03.953+05:30",
    "price": 6224.81
  },
  {
    "id": 1974246,
    "date_time": "2020-03-04T11:21:03.981+05:30",
    "price": 6069.51
  },
  {
    "id": 1974873,
    "date_time": "2020-03-04T11:49:34.263+05:30",
    "price": 6140.6
  },
  {
    "id": 1975511,
    "date_time": "2020-03-04T12:18:33.635+05:30",
    "price": 6314.14
  },
  {
    "id": 1976149,
    "date_time": "2020-03-04T12:47:33.992+05:30",
    "price": 6297.37
  },
  {
    "id": 1976776,
    "date_time": "2020-03-04T13:16:03.521+05:30",
    "price": 6144.89
  },
  {
    "id": 1977414,
    "date_time": "2020-03-04T13:45:03.642+05:30",
    "price": 6130.23
  },
  {
    "id": 1978041,
    "date_time": "2020-03-04T14:13:34.303+05:30",
    "price": 6290.45
  },
  {
    "id": 1978679,
    "date_time": "2020-03-04T14:42:34.275+05:30",
    "price": 6314.83
  },
  {
    "id": 1979306,
    "date_time": "2020-03-04T15:11:04.227+05:30",
    "price": 6150.38
  }
];
