import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const InsightCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),
      ),
    );
  }
}
