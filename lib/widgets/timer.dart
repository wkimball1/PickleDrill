import 'package:flutter/material.dart';
import '../providers/timer_provider.dart';
import '../resources/timer_service.dart';

class TimerCard extends StatefulWidget {
  const TimerCard({super.key});

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  @override
  Widget build(BuildContext context) {
    var timerService = TimerService.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AnimatedBuilder(
          animation: timerService, // listen to ChangeNotifier
          builder: (context, child) {
            // this part is rebuilt whenever notifyListeners() is called
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Elapsed: ${timerService.currentDuration}'),
                ElevatedButton(
                  onPressed: !timerService.isRunning
                      ? timerService.start
                      : timerService.stop,
                  child: Text(!timerService.isRunning ? 'Start' : 'Stop'),
                ),
                ElevatedButton(
                  onPressed: timerService.reset,
                  child: Text('Reset'),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
