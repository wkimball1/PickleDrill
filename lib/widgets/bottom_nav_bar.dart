import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickledrill/screens/workout_screen.dart';
import 'package:pickledrill/screens/create_workout_screen.dart';
import 'package:pickledrill/widgets/add_workout.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../providers/drill_provider.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> screens() {
    return [
      WorkoutScreen(physics: AlwaysScrollableScrollPhysics()),
      const CreateWorkoutScreen(),
      ProfileScreen(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
      AddWorkout(session: false),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/pickleball_icon.png', height: 40, width: 40),
        title: ("Workout"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: screens(),
      items: _navBarItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
