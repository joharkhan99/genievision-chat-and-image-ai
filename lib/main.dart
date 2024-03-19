import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:genievision/screens/chat_screen.dart';
import 'package:genievision/screens/image_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> test(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
    if (pickedFile != null) {
      const String apiKey = 'AIzaSyBqbJzQPpcZTkJJARtW02EiSWW8GFJpDe0';

      final File imageFile = File(pickedFile.path);
      final imageBytes = await imageFile.readAsBytes();

      if (imageBytes.length > 4 * 1024 * 1024) {
        throw Exception('Image size exceeds the maximum allowed size.');
      }

      final prompt = TextPart("Please explain the contents of this image.");
      final imagePart = DataPart('image/jpeg', imageBytes);

      final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);
      print(response.text);
    } else {
      // User canceled image selection
      print('No image selected.');
    }
  }

  final _pages = [
    const ImageScreen(),
    const ChatScreen(),
  ];

  int _selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 17, 20, 27),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(66, 39, 44, 61),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 17, 20, 27),
          selectedItemColor: Color.fromARGB(255, 49, 156, 90),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GenieVision'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.image_outlined),
              activeIcon: Icon(Icons.image_rounded),
              label: 'Image',
              tooltip: 'Image Explanation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(Icons.chat_rounded),
              label: 'Chat',
              tooltip: 'AI Chatbot',
            ),
          ],
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }
}
