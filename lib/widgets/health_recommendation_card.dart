import 'package:flutter/material.dart';
import '../models/health_recommendation.dart';

class HealthRecommendationCard extends StatelessWidget {
  final HealthRecommendation rec;

  const HealthRecommendationCard({super.key, required this.rec});

  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (rec.type) {
      case RecommendationType.sleep:
        icon = Icons.bedtime;
        break;
      case RecommendationType.bp:
        icon = Icons.favorite;
        break;
      case RecommendationType.diet:
        icon = Icons.restaurant;
        break;
      default:
        icon = Icons.directions_walk;
    }

    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(rec.message),
      ),
    );
  }
}
