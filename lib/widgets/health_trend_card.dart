import 'package:flutter/material.dart';
import '../models/health_trend.dart';

class HealthTrendCard extends StatelessWidget {
  final HealthTrend trend;

  const HealthTrendCard({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (trend.direction) {
      case TrendDirection.improving:
        color = Colors.green;
        icon = Icons.trending_up;
        break;
      case TrendDirection.worsening:
        color = Colors.red;
        icon = Icons.trending_down;
        break;
      default:
        color = Colors.grey;
        icon = Icons.trending_flat;
    }

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(trend.message),
      ),
    );
  }
}
