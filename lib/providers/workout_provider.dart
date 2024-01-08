import 'package:flutter/widgets.dart';
import '../models/workouts.dart';
import '../resources/auth_methods.dart';
import 'package:uuid/uuid.dart';

class WorkoutProvider with ChangeNotifier {
  Workouts? _workout;

  Workouts get getWorkout => _workout!;

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

  bool removeDrills(drill) {
    return _workout!.drills.remove(drill);
  }

  void deleteWorkout(workoutId) {
    if (_workout?.workoutId == workoutId) {
      _workout = null;
    }
  }
}
