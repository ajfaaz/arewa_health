import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'weekly_health_model.dart';

class WeeklyHealthChart extends StatelessWidget {
  final List<WeeklyHealthData> data;

  const WeeklyHealthChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No weekly data yet"));
    }

    final avgScore =
        data.map((e) => e.score).reduce((a, b) => a + b) / data.length;

    String? feedback;
    if (avgScore < 60) {
      feedback = "⚠ Health trend declining. Review sleep & BP.";
    } else if (avgScore > 80) {
      feedback = "✅ Excellent progress this week!";
    }

    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                _scoreLine(),
                _bpLine(),
                _sleepLine(),
              ],
            ),
          ),
        ),
        if (feedback != null) ...[
          const SizedBox(height: 8),
          Text(
            feedback,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }

  LineChartBarData _scoreLine() => LineChartBarData(
        spots: data
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.score.toDouble()))
            .toList(),
        isCurved: true,
        barWidth: 3,
      );

  LineChartBarData _bpLine() => LineChartBarData(
        spots: data
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.systolic.toDouble()))
            .toList(),
        isCurved: true,
        barWidth: 2,
      );

  LineChartBarData _sleepLine() => LineChartBarData(
        spots: data
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.sleepHours))
            .toList(),
        isCurved: true,
        barWidth: 2,
      );
}
