import 'package:flutter/material.dart';
import 'bp_service.dart';
import 'bp_utils.dart';

class BPScreen extends StatefulWidget {
  const BPScreen({super.key});

  @override
  State<BPScreen> createState() => _BPScreenState();
}

class _BPScreenState extends State<BPScreen> {
  final _sys = TextEditingController();
  final _dia = TextEditingController();
  final _pulse = TextEditingController();

  final BPService _service = BPService();
  bool loading = false;

  Future<void> save() async {
    if (_sys.text.isEmpty || _dia.text.isEmpty) return;

    final systolic = int.parse(_sys.text);
    final diastolic = int.parse(_dia.text);
    final pulse = _pulse.text.isEmpty ? null : int.parse(_pulse.text);

    final category = classifyBP(systolic, diastolic);

    setState(() => loading = true);

    await _service.saveBP(
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse ?? 0,
      category: category,
    );

    setState(() => loading = false);
    if (!mounted) return;

    if (category.contains("Stage") ||
        category == "Hypertensive Crisis") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Blood Pressure Alert"),
          content: Text(
            "Your BP is classified as $category.\n"
            "Please monitor closely or consult a doctor.",
          ),
        ),
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blood Pressure")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _sys,
              decoration: const InputDecoration(labelText: "Systolic"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dia,
              decoration: const InputDecoration(labelText: "Diastolic"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pulse,
              decoration: const InputDecoration(labelText: "Pulse (optional)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : save,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Save Reading"),
            ),
          ],
        ),
      ),
    );
  }
}
