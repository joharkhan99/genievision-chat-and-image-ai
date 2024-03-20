import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SelectionArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // chat messages
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Jul 12, 2021 10:00 AM",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 100, 100, 100),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'I need help with my account. I am unable to login. I have tried resetting my password but it is not working.',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jul 12, 2021 10:00 AM",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 100, 100, 100),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 49, 49, 49),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Please provide me with your email address.',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // bottom buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Send'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
