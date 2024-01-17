import 'package:flutter/widgets.dart';
import 'dart:async';
import '../providers/timer_provider.dart';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier {
  late Stopwatch _watch;
  Timer? _timer;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;

  bool get isRunning => _timer != null;

  TimerService() {
    _watch = Stopwatch();
  }

  void _onTick(Timer timer) {
    _currentDuration = _watch.elapsed;

    // notify all listening widgets
    notifyListeners();
  }

  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _watch.start();

    notifyListeners();
  }

  void stop() {
    _timer!.cancel();
    _timer = null;
    _watch.stop();
    _currentDuration = _watch.elapsed;

    notifyListeners();
  }

  void reset() {
    stop();
    _watch.reset();
    _currentDuration = Duration.zero;

    notifyListeners();
  }

  static TimerService of(BuildContext context) {
    var provider =
        context.dependOnInheritedWidgetOfExactType<TimerServiceProvider>()
            as TimerServiceProvider;
    return provider.service;
  }
}
