import 'dart:async';

class TimerService {
  final Duration total;
  late Duration _remaining;
  Timer? _timer;

  final _controller = StreamController<Duration>.broadcast();

  Stream<Duration> get stream => _controller.stream;

  TimerService({required this.total}) {
    _remaining = total;
  }

  void start() {
    _timer?.cancel();
    _remaining = total;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _remaining -= Duration(seconds: 1);

      if (_remaining <= Duration.zero) {
        _remaining = Duration.zero;
        _controller.add(_remaining);
        stop();
      } else {
        _controller.add(_remaining);
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _controller.close();
  }

  Duration get remaining => _remaining;
}