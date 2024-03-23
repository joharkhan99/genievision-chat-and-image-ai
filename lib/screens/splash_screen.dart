import 'dart:async';
import 'package:flutter/material.dart';
import 'package:genievision/screens/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 69, 161, 72),
            Color.fromARGB(255, 19, 196, 146),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/splash.png',
              width: 150,
              height: 150,
            ),
            Text(
              "GenieVision",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Your personal AI assistant",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(153, 255, 255, 255),
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
