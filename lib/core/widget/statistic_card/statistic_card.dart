import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:reusekit/core/theme/theme_config.dart'; // Add this line

enum StatisticCardChartType {
  line,
  spline,
  column,
  scatter,
}

enum StatisticCardMode {
  normal,
  outlined,
}

class StatisticCard extends StatelessWidget {
  final String title;
  final double value;
  final IconData? icon;
  final Color? color;
  final List<Map>? chartData;
  final StatisticCardChartType chartType;
  final double? height;
  final StatisticCardMode mode;

  const StatisticCard({
    Key? key,
    required this.title,
    this.value = 0,
    this.icon,
    this.color,
    this.chartData,
    this.chartType = StatisticCardChartType.spline,
    this.height,
    this.mode = StatisticCardMode.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 90.0,
      child: Card(
        color: mode == StatisticCardMode.outlined ? Colors.white : color,
        shape: mode == StatisticCardMode.outlined
            ? RoundedRectangleBorder(
                side: BorderSide(color: color ?? Colors.black, width: 2.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(radiusMd),
                ),
              )
            : null,
        child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spSm, // Use spMd from theme_config
                  vertical: spSm, // Use spLg from theme_config
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: spXs,
                  children: [
                    if (icon != null) ...[
                      CircleAvatar(
                        backgroundColor: mode == StatisticCardMode.outlined
                            ? color
                            : Colors.white,
                        radius: 14.0,
                        child: Icon(
                          icon,
                          color: mode == StatisticCardMode.outlined
                              ? Colors.white
                              : color,
                          size: 14,
                        ),
                      ),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            // flex: height == null ? 0 : 2,
                            flex: 0,
                            child: Container(
                                transform: Matrix4.translationValues(
                                  0.0,
                                  height == null
                                      ? 0
                                      : constraints.maxHeight * 0.1,
                                  0,
                                ),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mode == StatisticCardMode.outlined
                                        ? color
                                        : Colors.white,
                                  ),
                                )),
                          ),
                          Expanded(
                            // flex: height == null ? 0 : 3,
                            flex: 0,
                            child: FittedBox(
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: mode == StatisticCardMode.outlined
                                      ? color
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (chartData != null)
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(0.0),
                              child: SfCartesianChart(
                                primaryXAxis: const NumericAxis(
                                  isVisible: false,
                                ),
                                primaryYAxis: const NumericAxis(
                                  isVisible: false,
                                ),
                                plotAreaBorderColor: Colors.transparent,
                                margin: const EdgeInsets.all(0.0),
                                series: <CartesianSeries>[
                                  if (chartType ==
                                      StatisticCardChartType.spline)
                                    SplineSeries<Map, int>(
                                      color: mode == StatisticCardMode.outlined
                                          ? color
                                          : Colors.white,
                                      dataSource: chartData!,
                                      xValueMapper: (Map data, _) =>
                                          data["year"],
                                      yValueMapper: (Map data, _) =>
                                          data["sales"],
                                    ),
                                  if (chartType == StatisticCardChartType.line)
                                    LineSeries<Map, int>(
                                      color: mode == StatisticCardMode.outlined
                                          ? color
                                          : Colors.white,
                                      dataSource: chartData!,
                                      xValueMapper: (Map data, _) =>
                                          data["year"],
                                      yValueMapper: (Map data, _) =>
                                          data["sales"],
                                    ),
                                  if (chartType ==
                                      StatisticCardChartType.column)
                                    ColumnSeries<Map, int>(
                                      color: mode == StatisticCardMode.outlined
                                          ? color
                                          : Colors.white,
                                      dataSource: chartData!,
                                      xValueMapper: (Map data, _) =>
                                          data["year"],
                                      yValueMapper: (Map data, _) =>
                                          data["sales"],
                                    ),
                                  if (chartType ==
                                      StatisticCardChartType.scatter) ...[
                                    SplineSeries<Map, int>(
                                      color: mode == StatisticCardMode.outlined
                                          ? color
                                          : Colors.white,
                                      dataSource: chartData!,
                                      xValueMapper: (Map data, _) =>
                                          data["year"],
                                      yValueMapper: (Map data, _) =>
                                          data["sales"],
                                    ),
                                    ScatterSeries<Map, int>(
                                      color: mode == StatisticCardMode.outlined
                                          ? color
                                          : Colors.white,
                                      borderColor:
                                          mode == StatisticCardMode.outlined
                                              ? color!
                                              : Colors.white,
                                      borderWidth: 2,
                                      dataSource: chartData!,
                                      xValueMapper: (Map data, _) =>
                                          data["year"],
                                      yValueMapper: (Map data, _) =>
                                          data["sales"],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
