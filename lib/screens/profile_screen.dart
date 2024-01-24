import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pickledrill/screens/workout_screen.dart';
import '../resources/auth_methods.dart';
import 'login_screen.dart';
import '../utils.dart';
import '../colors.dart';
import '../widgets/follow_button.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List workoutData = [];
  var userData = {};
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var workoutSnap = await FirebaseFirestore.instance
          .collection('workouts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      workoutData = workoutSnap.docs;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              centerTitle: false,
            ),
            body: Center(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Column(children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          widget.uid
                                      ? FollowButton(
                                          text: 'Sign Out',
                                          backgroundColor: mobileButtonColor,
                                          textColor: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          borderColor: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          function: () async {
                                            await AuthMethods().signOut();
                                            if (context.mounted) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                              );
                                            }
                                          },
                                        )
                                      : const Text("hi"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        top: 1,
                        left: 20,
                      ),
                      child: Text(
                        userData['rating'].toString(),
                      ),
                    ),
                    WorkoutScreen(physics: ClampingScrollPhysics()),
                  ]),
                ],
              ),
            ),
          );
  }
}
