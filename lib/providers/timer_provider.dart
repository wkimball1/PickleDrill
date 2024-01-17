import 'package:flutter/widgets.dart';
import 'dart:async';
import '../resources/timer_service.dart';
import 'package:flutter/material.dart';

class TimerServiceProvider extends InheritedWidget {
  const TimerServiceProvider(
      {Key? key, required this.service, required Widget child})
      : super(key: key, child: child);

  final TimerService service;

  @override
  bool updateShouldNotify(TimerServiceProvider old) => service != old.service;
}
