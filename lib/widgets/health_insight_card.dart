import 'package:flutter/material.dart';
import '../models/health_insight.dart';

class HealthInsightCard extends StatelessWidget {
  final HealthInsight insight;

  const HealthInsightCard({super.key, required this.insight});

  Color get color {
    switch (insight.severity) {
      case InsightSeverity.danger:
        return Colors.red.shade100;
      case InsightSeverity.warning:
        return Colors.orange.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  IconData get icon {
    switch (insight.severity) {
      case InsightSeverity.danger:
        return Icons.warning_rounded;
      case InsightSeverity.warning:
        return Icons.info_outline;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        leading: Icon(icon),
        title: Text(insight.title),
        subtitle: Text(insight.message),
      ),
    );
  }
}
