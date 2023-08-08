import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/widgets/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraphWidget extends StatelessWidget {
  final int maxHabitCount;
  final List dataList;
  const BarGraphWidget(
      {super.key, required this.maxHabitCount, required this.dataList});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        firstValue: dataList[0],
        secondValue: dataList[1],
        thirdValue: dataList[2],
        fourthValue: dataList[3],
        fifthValue: dataList[4],
        sixthValue: dataList[5],
        seventhValue: dataList[6]);
    myBarData.initializeBarData();
    return SizedBox(
      height: 150,
      child: BarChart(BarChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          maxY: maxHabitCount.toDouble() + 5,
          minY: 0,
          barGroups: myBarData.barData
              .map(
                (data) => BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                        toY: data.y.toDouble(),
                        color: greenColor,
                        width: 20,
                        borderRadius: BorderRadius.circular(5),
                        backDrawRodData: BackgroundBarChartRodData(
                            color: grayColor,
                            show: true,
                            toY: maxHabitCount.toDouble() + 5)),
                  ],
                ),
              )
              .toList())),
    );
  }
}
