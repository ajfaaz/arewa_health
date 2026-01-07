import 'package:flutter/material.dart';

Widget bpStatusBadge(int sys, int dia) {
  if (sys >= 140 || dia >= 90) {
    return const Text("High BP ⚠",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
  } else if (sys >= 120 || dia >= 80) {
    return const Text("Elevated BP",
        style: TextStyle(color: Colors.orange));
  } else {
    return const Text("Normal BP ✔",
        style: TextStyle(color: Colors.green));
  }
}