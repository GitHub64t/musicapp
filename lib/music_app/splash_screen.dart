import 'package:flutter/material.dart';
import 'dart:async';

import 'package:musicapp/music_app/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
   void initState() {
    super.initState();
    // Set a delay before navigating to the next screen (e.g., 3 seconds)
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>const HomeScreen()),
      );
    });
  }
  Widget build(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(
        gradient: RadialGradient(colors: [Color.fromARGB(255, 96, 62, 169),Color.fromARGB(255, 83, 51, 151),
        Color(0xFF43297A),Color.fromARGB(255, 49, 28, 94),Color(0xFF19093B),Colors.black],
        radius: 1)
      ),
      child: Center(
        child: Center(child:Image.asset("assets/images/Black_and_White_Flat_Illustrative_Music_Studio_Logo-removebg-preview.png"),
        // Text("ECHOSYNC",style: TextStyle(color: Colors.white,decoration: TextDecoration.none),)
        ),
      ),
    );
  }
}