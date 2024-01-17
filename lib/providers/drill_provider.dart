import 'package:flutter/widgets.dart';
import '../models/drills.dart';
import 'package:uuid/uuid.dart';
import '../resources/firestore_methods.dart';
import 'dart:developer';

class DrillProvider with ChangeNotifier {
  Drills? _drill;

  Drills? get getDrill => _drill;

  Drills setDrill(name, description, url, level, focus) {
    _drill = Drills(
        name: name,
        drillId: const Uuid().v1(), // creates unique id based on time
        description: description,
        url: url,
        level: level,
        focus: focus);

    return _drill!;
  }

  void addFocus(focus) {
    _drill?.focus.add(focus);
    notifyListeners();
  }

  Future<void> addAllDrills() async {
    List<Drills> drills = [];
    drills.add(setDrill(
      'Solo Paddle Hits',
      'Repeatedly hit the ball straight in the air.  See how many you can do in a row.  Try not to move around too much',
      '',
      'beginner',
      ['volley'],
    ));
    drills.add(setDrill(
        'Easy Dinking',
        'Stand with your toes on the kitchen line and a partner opposite.  Aim to hit dinks that bounce in the kitchen in one half of the court',
        '',
        'beginner',
        ['dink']));
    drills.add(setDrill(
        'Cross-Court Dinking',
        'You and your partner stand on the kitchen line, but not directly across frome each other.  Spend some time on both directions of cross-court',
        '',
        'intermediate',
        ['dink']));
    drills.add(setDrill(
        'Soft Kitchen Volleys',
        'Both you and your drill partner stand opposite each other in one half of the court.  Hit easy volleys to each other.  See how many you can do in a row.  As you get better, speed the ball up a bit and try hitting it a little lower',
        '',
        'beginner',
        ['volley', 'drop']));
    drills.add(setDrill(
        '7-11',
        'One player at kitchen line and one at baseline on half the court.  First shot is cooperative.  Then play out the point.  Baseline player is trying to get to 7.  Kitchen player is trying to get to 11...rally scoring.',
        '',
        'beginner',
        ['volley', 'drop']));
    drills.add(setDrill(
        'Serve Shoot-out',
        'Place cones at the back 25% of the serving target area.  Both players stand on the opposite side of the net, one on the even side and the other on the odd side.  Take turns calling the cone you are going for and seeing if you can hit it.  Score who gets more hits.',
        '',
        'beginner',
        ['serve']));
    for (final drill in drills) {
      FireStoreMethods().uploadDrill(drill);
      inspect(drill);
    }
  }
}
