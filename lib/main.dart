import 'package:flutter/material.dart';
import 'package:snowcone/connectivity_wrapper.dart';
import 'package:snowcone/firebase_options.dart';
import 'package:snowcone/screens/disclaimer.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SnowCone",
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: false,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white54),
        ),
      ),
      home: ConnectivityWrapper(child: Disclaimer()),
    );
  }
}
