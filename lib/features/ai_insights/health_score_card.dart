import 'package:flutter/material.dart';
import 'health_score_model.dart';

class HealthScoreCard extends StatelessWidget {
  final HealthScore healthScore;

  const HealthScoreCard({super.key, required this.healthScore});

  @override
  Widget build(BuildContext context) {
    Color color = healthScore.score >= 80
        ? Colors.green
        : healthScore.score >= 60
            ? Colors.orange
            : Colors.red;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: color),
                const SizedBox(width: 8),
                const Text("Today's Health Score",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text("${healthScore.score}/100",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 8),
            Text(
              healthScore.message,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
