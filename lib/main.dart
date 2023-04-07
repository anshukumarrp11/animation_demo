import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dot Chart',
      home: DotChart(),
    );
  }
}

class DotChart extends StatefulWidget {
  @override
  _DotChartState createState() => _DotChartState();
}

class _DotChartState extends State<DotChart> {
  // List of points to display on the chart
  List<Point> _points = [];

  // List of chart series to display
  List<charts.Series<Point, int>> _seriesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dot Chart'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
          ),
          Expanded(
            child: charts.LineChart(
              _createChartSeries(),
              animate: false,
              defaultRenderer: charts.LineRendererConfig(
                includePoints: true,
                includeArea: false,
                includeLine: true,
                customRendererId: 'customDot',
              ),
              domainAxis: charts.NumericAxisSpec(
                renderSpec: charts.NoneRenderSpec(),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.NoneRenderSpec(),
              ), // disable y-axis
              customSeriesRenderers: [
                charts.PointRendererConfig(
                  customRendererId: 'customDot',
                  radiusPx: 100,
                  strokeWidthPx: 2.0,
                )
              ],
            ),
          ),
          // Add a button to add a new point to the chart
          ElevatedButton(
            onPressed: _addPoint,
            child: Text('Add Point'),
          ),

          // Add a button to clear all points from the chart
          // ElevatedButton(
          //   onPressed: _clearPoints,
          //   child: Text('Clear Points'),
          // ),
        ],
      ),
    );
  }

  // static final _customDotRenderer = charts.PointRendererConfig(
  //   customRendererId: 'customDot',
  //   radiusPx: 5,
  //   strokeWidthPx: 2.0,
  // );
  // Create the chart series from the list of points
  // Create the chart series from the list of points
  List<charts.Series<Point, int>> _createChartSeries() {
    _seriesList.clear();
    _seriesList.add(
      charts.Series<Point, int>(
        id: 'Points',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (point, _) => point.x,
        measureFn: (point, _) => point.y,
        data: _points,
        // Add intermediate points between each two existing points
        measureLowerBoundFn: (point, index) => _points[index!].y,
        measureUpperBoundFn: (point, index) => point.y,
        domainLowerBoundFn: (point, index) => _points[index!].x + 5,
        domainUpperBoundFn: (point, index) => point.x,
      ),
    );
    return _seriesList;
  }

  // Add a new point to the chart
  void _addPoint() {
    setState(() {
      // Add the new point with X value equal to the number of points already on the chart
      if (_points.isEmpty) {
        _points.add(Point(0, 5)); // Add a dot at the beginning of the chart
      } else {
        _points.add(Point(_points.length, 5));
      }
    });
  }

  // Clear all points from the chart
  void _clearPoints() {
    setState(() {
      _points.clear();
    });
  }
}

// A simple class to represent a point on the chart
class Point {
  final int x;
  final double y;

  Point(this.x, this.y);
}
