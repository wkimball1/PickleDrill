import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickledrill/screens/workout_screen.dart';
import 'package:pickledrill/widgets/add_workout.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import './providers/drill_provider.dart';
import './providers/workout_provider.dart';
import './providers/saved_workouts_provider.dart';
import './providers/user_provider.dart';
import 'package:pickledrill/utils.dart';
import './providers/screen_index_provider.dart';
import 'package:provider/provider.dart';
import 'package:pickledrill/global_variable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  int _page = 0;
  int _maxItems = 2;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    addData();
    getData();
  }

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      // get workouts
      await Provider.of<WorkoutProvider>(context, listen: false)
          .getWorkoutsDB();
      await Provider.of<SavedWorkoutProvider>(context, listen: false)
          .getSavedWorkouts();
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    Provider.of<screenIndexProvider>(context, listen: false)
        .updateScreenIndex(page);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    Provider.of<screenIndexProvider>(context, listen: false)
        .updateScreenIndex(page);
  }

  @override
  Widget build(BuildContext context) {
    final screenindexprovider = Provider.of<screenIndexProvider>(context);
    _page = screenindexprovider.fetchCurrentScreenIndex;
    _maxItems = screenindexprovider.fetchMaxItems;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        // if (didPop) return;
        final NavigatorState navigator = Navigator.of(context);
        screenindexprovider.updateScreenIndex(
            Provider.of<screenIndexProvider>(context, listen: false)
                .fetchPreviousScreenIndex);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              color: Colors.black54,
              onPressed: () {},
              iconSize: 40,
            ),
          ],
          title: const Text("PickleDrill"),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
                child: const Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Messages'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: homeScreenItems[
            Provider.of<screenIndexProvider>(context).fetchCurrentScreenIndex],
        bottomNavigationBar: createBottomNavBar(),
      ),
    );
  }

  Widget createBottomNavBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.green),
        BottomNavigationBarItem(
            icon: Image.asset('assets/pickleball_icon.png',
                height: 40, width: 40),
            label: 'Workout',
            backgroundColor: Colors.yellow),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          backgroundColor: Colors.blue,
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: Provider.of<screenIndexProvider>(context)
                  .fetchCurrentScreenIndex >
              _maxItems
          ? 2
          : Provider.of<screenIndexProvider>(context).fetchCurrentScreenIndex,
      selectedItemColor: Colors.black,
      iconSize: 40,
      onTap: navigationTapped,
      elevation: 5,
    );
  }
}
