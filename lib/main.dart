import 'package:emee/pages/auth-page/signup.dart';
import 'package:emee/pages/chatroom/chatroom.dart';
import 'package:emee/pages/chatroom/patient_assesment.dart';
import 'package:emee/pages/home-page/navpage.dart';
import 'package:emee/pages/auth-page/login.dart';
import 'package:flutter/material.dart';
import 'package:emee/pages/home-page/widgets/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'emee',
      debugShowCheckedModeBanner : false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          primary: Color.fromRGBO(255, 182, 193, 1),
          primaryContainer: Color.fromRGBO(235, 235, 235, 1)
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.bold
          )
        )
      ),
      home: const LoginPage(),
    );
  }
}
