import 'package:accomplishr_mobile_app/utils/colors.dart';
import 'package:accomplishr_mobile_app/widgets/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraphWidget extends StatelessWidget {
  final int maxHabitCount;
  final List dataList;
  final List bottomList;
  const BarGraphWidget({
    super.key,
    required this.maxHabitCount,
    required this.dataList,
    required this.bottomList,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      firstValue: dataList[0],
      secondValue: dataList[1],
      thirdValue: dataList[2],
      fourthValue: dataList[3],
      fifthValue: dataList[4],
      sixthValue: dataList[5],
      seventhValue: dataList[6],
    );
    myBarData.initializeBarData();
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white60),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Habits Progress',
                style: TextStyle(
                  color: Color(0xff7589a2),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: BarChart(BarChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                    ),
                    maxY: maxHabitCount.toDouble(),
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
                              ),
                            ],
                          ),
                        )
                        .toList())),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = bottomList;

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
