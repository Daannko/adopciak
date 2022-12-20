import 'dart:async';

import 'package:adopciak/add_animal_screen.dart';
import 'package:adopciak/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  late StreamSubscription<User?> user;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {});
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? 'login_screen'
          : 'navbar_screen',
      routes: {
        // 'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'login_screen': (context) => LoginScreen(),
        'navbar_screen': (context) => NavBarScreen(),
        // 'add_anima_screen': (context) => AddAnimalScreen(),
      },
    );
  }
}
