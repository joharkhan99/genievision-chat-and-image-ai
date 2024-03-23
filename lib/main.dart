import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:genievision/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('chatMessages');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const WebContainer(
      app: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class WebContainer extends StatelessWidget {
  final MaterialApp app;
  const WebContainer({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return kIsWeb
        ? Container(
            color: Colors.black,
            child: FractionallySizedBox(
              widthFactor: screenWidth < 1000 ? 1.0 : 500 / screenWidth,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: const Color.fromARGB(255, 17, 20, 27),
                child: app,
              ),
            ),
          )
        : app;
  }
}
