import '../utils/bp_utils.dart';
import 'bp_category.dart';

class BPReading {
  final int systolic;
  final int diastolic;
  final DateTime recordedAt;

  BPReading({
    required this.systolic,
    required this.diastolic,
    required this.recordedAt,
  });

  String get category {
    final cat = classifyBP(systolic, diastolic);
    return bpLabel(cat);
  }

  bool get isHighRisk {
    final cat = classifyBP(systolic, diastolic);
    return cat == BpCategory.stage2 || cat == BpCategory.crisis;
  }
}
