import 'dart:async';
import 'package:demo/authentication/login.dart';
import 'package:demo/global/global.dart';
import 'package:demo/mainScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashSreen extends StatefulWidget {
  const SplashSreen({super.key});

  @override
  State<SplashSreen> createState() => _SplashSreenState();
}

class _SplashSreenState extends State<SplashSreen> {
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      if (firebaseAuth.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFB4B4B4),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/logo.png", scale: 2,),
                Text(
                  "FoodBlood",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
