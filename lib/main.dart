import 'package:flutter/material.dart';
import 'package:pickledrill/providers/screen_index_provider.dart';
import 'package:pickledrill/screens/add_drill_screen.dart';
import 'package:pickledrill/screens/workout_screen.dart';
import 'package:pickledrill/widgets/add_workout.dart';
import 'screens/login_screen.dart';
import 'providers/user_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/saved_workouts_provider.dart';
import 'providers/drill_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'colors.dart';
import '../providers/timer_provider.dart';
import '../resources/timer_service.dart';

void main() async {
  final timerService = TimerService();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(TimerServiceProvider(
    // provide timer service to all widgets of your app
    service: timerService,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<screenIndexProvider>(
            create: (_) => screenIndexProvider()),
        ChangeNotifierProvider<WorkoutProvider>(
          create: (_) => WorkoutProvider(),
        ),
        ChangeNotifierProvider<SavedWorkoutProvider>(
          create: (_) => SavedWorkoutProvider(),
        ),
        ChangeNotifierProvider<DrillProvider>(
          create: (_) => DrillProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PickleDrill',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        routes: {
          '/home': (context) => HomePage(),
          '/addworkout': (context) => AddWorkout()
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                print('data: $snapshot.data');
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const HomePage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
