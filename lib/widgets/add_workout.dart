import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/firestore_methods.dart';
import '../models/user.dart' as model;
import '../models/workouts.dart';
import '../utils.dart';
import '../colors.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import 'package:provider/provider.dart';
import '../screens/add_drill_screen.dart';
import 'dart:developer';
import '../providers/drill_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../home.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({super.key});

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  bool isLoading = false;
  bool isReady = true;
  int dateOfWorkout = DateTime.now().millisecondsSinceEpoch;
  DateTime workoutStart = DateTime.now();
  DateTime workoutEnd = DateTime.now();
  List drills = [];
  Workouts? workout;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _focusOfWorkoutController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    addDrills();
    createWorkout();
  }

  addDrills() async {
    DrillProvider drillProvider =
        Provider.of<DrillProvider>(context, listen: false);
    await drillProvider.addAllDrills();
  }

  createWorkout() async {
    setState(() {
      isLoading = true;
    });
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
    if (mounted) {
      final model.User? user =
          Provider.of<UserProvider>(context, listen: false).getUser;
      int lengthOfWorkout = workoutEnd.difference(workoutStart).inSeconds;

//check if workout already exists
      workout = Provider.of<WorkoutProvider>(context, listen: false).getWorkout;
      if (workout != null) {
        print('Workout already exists ${inspect(workout)}');
      } else {
        // start the loading
        workout = Provider.of<WorkoutProvider>(context, listen: false)
            .setWorkout(
                _nameController.text,
                user?.uid,
                _focusOfWorkoutController.text,
                drills,
                dateOfWorkout,
                lengthOfWorkout);
        print('created new workout: ${inspect(workout)}');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void uploadWorkout(Workouts workout) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadWorkout(workout);
      if (res == "success" && context.mounted) {
        Provider.of<WorkoutProvider>(context, listen: false)
            .deleteWorkout(workout.workoutId);

        if (context.mounted) {
          showSnackBar(
            context,
            'Created!',
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _focusOfWorkoutController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final WorkoutProvider workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: true);
    workout = workoutProvider.getWorkout;

    return (isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   onPressed: minimizeWorkout,
              // ),
              title: const Text(
                'Create Workout',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: workout != null && workout!.drills.isNotEmpty
                      ? () => uploadWorkout(workout!)
                      : () => showSnackBar(
                            context,
                            ('must add a drill'),
                          ),
                  child: const Text(
                    "Finish Workout",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: [
                workout != null
                    ? ListView(shrinkWrap: true, children: [
                        for (final i in workout?.drills ?? [])
                          Dismissible(
                              direction: DismissDirection.endToStart,
                              resizeDuration: Duration(milliseconds: 200),
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                setState(()
                                    // TODO: implement your delete function and check direction if needed
                                    {
                                  Provider.of<WorkoutProvider>(context,
                                          listen: false)
                                      .removeDrills(i);
                                });
                              },
                              background: Container(
                                padding: EdgeInsets.only(left: 28.0),
                                alignment: AlignmentDirectional.centerStart,
                                color: Colors.red,
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                ),
                              ),
                              // secondaryBackground: ...,
                              child: Card(
                                color: Colors.white,
                                child: ListTile(title: Text(i['name'])),
                              )),
                      ])
                    : const SizedBox(height: 10),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddDrills(),
                        ),
                      ),
                      child: const Text(
                        "Add Drill",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )),
              ],
            ),
          ));
  }

  Widget createSlidable(var i) {
    final WorkoutProvider workoutProvider =
        Provider.of<WorkoutProvider>(context);

    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: .25,
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            // flex: 1,
            onPressed: (BuildContext context) async {
              await Provider.of<WorkoutProvider>(context, listen: false)
                  .removeDrills(i);
            },

            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: ListTile(title: Center(child: Text('${i['name']}'))),
    );
  }
}
