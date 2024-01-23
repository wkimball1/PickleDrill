import 'package:flutter/widgets.dart';
import '../models/workouts.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';

class WorkoutProvider with ChangeNotifier {
  Workouts? _workout;

  Workouts? get getWorkout => _workout;

  Workouts setWorkout(
      name, uid, focusOfWorkout, drills, dateOfWorkout, lengthOfWorkout) {
    _workout = Workouts(
        workoutId: const Uuid().v1(), // creates unique id based on time
        name: name,
        uid: uid,
        focusOfWorkout: focusOfWorkout,
        drills: [],
        dateOfWorkout: dateOfWorkout,
        lengthOfWorkout: lengthOfWorkout);

    notifyListeners();
    return _workout!;
  }

  void addDrills(drill) {
    _workout?.drills.add(drill);
    notifyListeners();
  }

  dynamic removeDrills(drill) {
    var removed = _workout!.drills.removeAt(drill);
    print(drill);
    inspect(_workout!.drills);
    notifyListeners();
    return removed;
  }

  void deleteWorkout(workoutId) {
    if (_workout?.workoutId == workoutId) {
      _workout = null;
      notifyListeners();
    }
  }
}
