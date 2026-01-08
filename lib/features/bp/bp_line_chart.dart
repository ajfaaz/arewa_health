import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BPLineChart extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  const BPLineChart(this.docs, {super.key});

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) return const Center(child: Text('No data'));

    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];
    final labels = <int, String>{};

    for (var i = 0; i < docs.length; i++) {
      final d = docs[i];
      final sys = (d['systolic'] as num).toDouble();
      final dia = (d['diastolic'] as num).toDouble();
      final created = d['createdAt'];
      DateTime dt;
      if (created is Timestamp) {
        dt = created.toDate();
      } else if (created is DateTime) {
        dt = created;
      } else {
        dt = DateTime.now();
      }

      systolicSpots.add(FlSpot(i.toDouble(), sys));
      diastolicSpots.add(FlSpot(i.toDouble(), dia));

      // Store label for bottom axis (show for first, last and a few intermediate)
      if (i == 0 || i == docs.length - 1 || i % (docs.length ~/ 4 + 1) == 0) {
        labels[i] = DateFormat('MM/dd').format(dt);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 260,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    final text = labels[idx] ?? '';
                    return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: const TextStyle(fontSize: 10)));
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 20)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            minX: 0,
            maxX: (docs.length - 1).toDouble(),
            lineBarsData: [
              LineChartBarData(
                spots: systolicSpots,
                isCurved: true,
                color: Colors.red,
                barWidth: 2,
                dotData: FlDotData(show: false),
              ),
              LineChartBarData(
                spots: diastolicSpots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
