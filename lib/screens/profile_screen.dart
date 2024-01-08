import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../resources/auth_methods.dart';
import 'login_screen.dart';
import '../utils.dart';
import '../colors.dart';
import '../widgets/follow_button.dart';
import '../resources/firestore_methods.dart';
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
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                // Row(
                                //   mainAxisSize: MainAxisSize.max,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //     children: [
                                //      buildStatColumn(postLen, "posts"),
                                //      buildStatColumn(followers, "followers"),
                                //      buildStatColumn(following, "following"),
                                //    ],
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor: mobileButtonColor,
                                            textColor:
                                                Color.fromARGB(255, 0, 0, 0),
                                            borderColor:
                                                Color.fromARGB(255, 0, 0, 0),
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
                                        : Text("hi"),
                                    // : isFollowing
                                    //     ? FollowButton(
                                    //         text: 'Unfollow',
                                    //         backgroundColor: Colors.white,
                                    //         textColor: Colors.black,
                                    //         borderColor: Colors.grey,
                                    //         function: () async {
                                    //           await FireStoreMethods()
                                    //               .followUser(
                                    //             FirebaseAuth.instance
                                    //                 .currentUser!.uid,
                                    //             userData['uid'],
                                    //           );

                                    //           setState(() {
                                    //             isFollowing = false;
                                    //             followers--;
                                    //           });
                                    //         },
                                    //       )
                                    //     : FollowButton(
                                    //         text: 'Follow',
                                    //         backgroundColor: Colors.blue,
                                    //         textColor: Colors.white,
                                    //         borderColor: Colors.blue,
                                    //         function: () async {
                                    //           await FireStoreMethods()
                                    //               .followUser(
                                    //             FirebaseAuth.instance
                                    //                 .currentUser!.uid,
                                    //             userData['uid'],
                                    //           );

                                    // setState(() {
                                    //   isFollowing = true;
                                    //   followers++;
                                    // });
                                    // },
                                    // )
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
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['rating'].toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // FutureBuilder(
                //   future: FirebaseFirestore.instance
                //       .collection('posts')
                //       .where('uid', isEqualTo: widget.uid)
                //       .get(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }

                //     return GridView.builder(
                //       shrinkWrap: true,
                //       itemCount: (snapshot.data! as dynamic).docs.length,
                //       gridDelegate:
                //           const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 3,
                //         crossAxisSpacing: 5,
                //         mainAxisSpacing: 1.5,
                //         childAspectRatio: 1,
                //       ),
                //       itemBuilder: (context, index) {
                //         DocumentSnapshot snap =
                //             (snapshot.data! as dynamic).docs[index];

                //         return SizedBox(
                //           child: Image(
                //             image: NetworkImage(snap['postUrl']),
                //             fit: BoxFit.cover,
                //           ),
                //         );
                //       },
                //     );
                //   },
                // )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
