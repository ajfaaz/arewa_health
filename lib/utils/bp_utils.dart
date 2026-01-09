import 'package:flutter/material.dart';
import '../models/bp_category.dart';

BpCategory classifyBP(int sys, int dia) {
  if (sys >= 180 || dia >= 120) return BpCategory.crisis;
  if (sys >= 140 || dia >= 90) return BpCategory.stage2;
  if (sys >= 130 || dia >= 81) return BpCategory.stage1;
  if (sys >= 121 && dia < 81) return BpCategory.elevated;
  return BpCategory.normal;
}

String bpLabel(BpCategory c) {
  switch (c) {
    case BpCategory.normal: return "Normal";
    case BpCategory.elevated: return "Elevated";
    case BpCategory.stage1: return "High BP (Stage 1)";
    case BpCategory.stage2: return "High BP (Stage 2)";
    case BpCategory.crisis: return "Hypertensive Crisis";
  }
}

Color bpColor(BpCategory c) {
  switch (c) {
    case BpCategory.normal: return Colors.green;
    case BpCategory.elevated: return Colors.yellow.shade800;
    case BpCategory.stage1: return Colors.orange;
    case BpCategory.stage2: return Colors.deepOrange;
    case BpCategory.crisis: return Colors.red.shade900;
  }
}
