import 'package:flutter/material.dart';
import '../models/health_score.dart';

class HealthScoreCard extends StatelessWidget {
  final HealthScore score;

  const HealthScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Health Score",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "${score.score}",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(score.label),
            const SizedBox(height: 8),
            Text(
              score.message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
