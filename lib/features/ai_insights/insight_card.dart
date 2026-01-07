import 'package:flutter/material.dart';
import 'insight_model.dart';

class InsightCard extends StatelessWidget {
  final HealthInsight insight;

  const InsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (insight.type) {
      case InsightType.warning:
        color = Colors.red;
        icon = Icons.warning;
        break;
      case InsightType.success:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.blue;
        icon = Icons.info;
    }

    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(insight.title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        subtitle: Text(insight.message),
      ),
    );
  }
}
