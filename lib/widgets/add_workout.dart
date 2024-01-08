import 'package:flutter/material.dart';
import 'drill_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as model;
import '../models/workouts.dart';
import '../utils.dart';
import '../colors.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import 'package:provider/provider.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({super.key});

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  bool isLoading = false;
  int dateOfWorkout = DateTime.now().millisecondsSinceEpoch;
  DateTime workoutStart = DateTime.now();
  DateTime workoutEnd = DateTime.now();
  List drills = [];
  Workouts? workout;


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _focusOfWorkoutController =
      TextEditingController();

  void createWorkout() async {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    int lengthOfWorkout = workoutEnd.difference(workoutStart).inSeconds;

    setState(() {
      isLoading = true;
    });
    // start the loading
          workout = Provider.of<WorkoutProvider>(context).setWorkout(
          _nameController.text,
          user.uid,
          _focusOfWorkoutController.text,
          drills,
          dateOfWorkout,
          lengthOfWorkout);

    setState(() {
      isLoading = true;
    });
  }
  void uploadWorkout(Workouts workout) async {

    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadWorkout(
          workout);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Created!',
          );
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }


  fetchAllDrills() async {
    final Workouts? _workout = Provider.of<WorkoutProvider>(context).getWorkout();
    if (_workout != null){
    try {
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection('workouts').doc(_workout.workoutID).collection('drills').get();
      _drills = snap.docs;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }}

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
    final WorkoutProvider workoutProvider = Provider.of<WorkoutProvider>(context);



    return Scaffold(
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
            onPressed: () => postWorkout(workout),
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
        children: <Widget>[
          isLoading
              ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.only(top: 0.0)),
          const Divider(),
          Container(
            color: Colors.blueAccent,
            child: TextButton(
            
            onPressed: () => get(userProvider.getUser.uid, _drills),
            child: const Text(
              "Add Drill",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
          )
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  userProvider.getUser.photoUrl,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Write a caption...", border: InputBorder.none),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45.0,
                width: 45.0,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter,
                      image: MemoryImage(_file!),
                    )),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
