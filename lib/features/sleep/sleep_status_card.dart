import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/sleep_utils.dart';

class SleepStatusCard extends StatefulWidget {
  final bool isSleeping;
  final DateTime? startTime;
  final Duration? lastSleepDuration;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const SleepStatusCard({
    super.key,
    required this.isSleeping,
    this.startTime,
    this.lastSleepDuration,
    required this.onStart,
    required this.onStop,
  });

  @override
  State<SleepStatusCard> createState() => _SleepStatusCardState();
}

class _SleepStatusCardState extends State<SleepStatusCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkTimer();
  }

  @override
  void didUpdateWidget(covariant SleepStatusCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkTimer();
  }

  void _checkTimer() {
    if (widget.isSleeping && (_timer == null || !_timer!.isActive)) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!widget.isSleeping) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isSleeping ? Colors.purple.shade50 : Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.isSleeping ? Icons.bedtime : Icons.nightlight_round,
                  color: Colors.purple,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isSleeping ? "Sleep in progress" : "Sleep Status",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (widget.isSleeping && widget.startTime != null) ...[
              Text("Started at: ${_formatTime(widget.startTime!)}"),
              const SizedBox(height: 4),
              Text("Duration: ${_formatDuration(DateTime.now().difference(widget.startTime!))}"),
              const SizedBox(height: 12),
              const Text("● Recording sleep data",
                  style: TextStyle(color: Colors.green)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onStop,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red),
                  child: const Text("Stop Sleep"),
                ),
              )
            ] else ...[
              Text(
                widget.lastSleepDuration != null
                    ? "Last sleep: ${_formatDuration(widget.lastSleepDuration!)}"
                    : "No sleep data yet",
              ),
              const SizedBox(height: 8),
              if (widget.lastSleepDuration != null)
                Text("Quality: ${sleepQualityLabel(sleepQualityFromSeconds(widget.lastSleepDuration!.inSeconds))}",
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onStart,
                  child: const Text("Start Sleep"),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return "${h}h ${m}m";
  }
}