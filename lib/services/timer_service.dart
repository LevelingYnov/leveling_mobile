import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TimerService {
  final Duration total;
  late Duration _remaining;
  Timer? _timer;
  final ValueNotifier<Duration> remainingNotifier;

  TimerService({required this.total})
      : _remaining = total,
        remainingNotifier = ValueNotifier(total);

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        _remaining = _remaining - const Duration(seconds: 1);
        remainingNotifier.value = _remaining;
      } else {
        _timer?.cancel();
      }
    });
  }

  void stop() => _timer?.cancel();

  void reset() {
    _timer?.cancel();
    _remaining = total;
    remainingNotifier.value = _remaining;
  }

  Duration get remaining => _remaining;
}

String format(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
}

Widget buildTimeContainer(TimerService timerService) {
  return ValueListenableBuilder<Duration>(
    valueListenable: timerService.remainingNotifier,
    builder: (context, remaining, child) {
      return Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Temps restant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              format(remaining),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: 1.0 - (remaining.inSeconds / timerService.total.inSeconds),
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ],
        ),
      );
    },
  );
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: buildTimeContainer(TimerService(total: Duration(minutes: 1))),
        ),
      ),
    ),
  );
}
