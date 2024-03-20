import 'package:flutter/material.dart';
import 'package:genievision/screens/chat_screen.dart';
import 'package:genievision/screens/image_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  void clearChatHistory() {
    final chatMessages = Hive.box('chatMessages');
    chatMessages.deleteAll(chatMessages.keys);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/image-screen': (context) => const ImageScreen(),
        '/chat-screen': (context) => const ChatScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 49, 156, 90),
          selectionColor: Color.fromARGB(66, 186, 248, 210),
          selectionHandleColor: Color.fromARGB(255, 49, 156, 90),
        ),
        primaryColor: const Color.fromARGB(255, 49, 156, 90),
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 17, 20, 27),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
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
          // show actions only on chat screen
          actions: _selectedIndex == 1
              ? [
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: clearChatHistory,
                            child: const Text('Clear Chat History'),
                          ),
                        ),
                      ];
                    },
                  )
                ]
              : null,
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
