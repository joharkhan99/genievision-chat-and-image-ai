import 'package:flutter/material.dart';
import 'package:genievision/database.dart';
import 'package:genievision/message_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputController = TextEditingController();

  List<Message> chatMessages = [];
  String apiKey = "AIzaSyBqbJzQPpcZTkJJARtW02EiSWW8GFJpDe0";
  late GenerativeModel model;

  @override
  void initState() {
    super.initState();
    chatMessages = Database().loadMessages();
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey, generationConfig: GenerationConfig(maxOutputTokens: 500));
  }

  String getDate(DateTime dateTime) {
    return "${dateTime.month} ${dateTime.day}, ${dateTime.year} ${dateTime.hour}:${dateTime.minute} ${dateTime.hour > 12 ? "PM" : "AM"}";
  }

  Future<void> generateMessage() async {
    if (_inputController.text.isEmpty) {
      return;
    }

    Message message = Message();
    message.sender = 'user';
    message.time = getDate(DateTime.now());
    message.text = _inputController.text;
    Database().saveData(message);

    setState(() {
      chatMessages = Database().loadMessages();
    });

    List<Content> history = Database().getHistory();

    final chat = model.startChat(
      history: [
        Content.text('Hello, I have 2 dogs in my house.'),
        Content.model([TextPart('Great to meet you. What would you like to know?')])
      ],
    );
    var content = Content.text(_inputController.text);
    var response = await chat.sendMessage(content);

    print(response.text!);

    Message responseMessage = Message();
    responseMessage.sender = 'genie';
    responseMessage.time = getDate(DateTime.now());
    responseMessage.text = response.text!;
    Database().saveData(responseMessage);

    setState(() {
      chatMessages = Database().loadMessages();
    });
    // final chat = model.startChat(history: [
    //   Content.text('Hello, I have 2 dogs in my house.'),
    //   Content.model([TextPart('Great to meet you. What would you like to know?')]),
    // ]);
    // var content = Content.text('can you explain what conversation we are having?');
    // var response = await chat.sendMessage(content);
    // print(response.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SelectionArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // chat messages

                    for (var i = 0; i < chatMessages.length; i++)
                      chatMessages[i].sender == 'user'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          chatMessages[i].time,
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 100, 100, 100),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            chatMessages[i].text,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chatMessages[i].time,
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 100, 100, 100),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 49, 49, 49),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            chatMessages[i].text,
                                            style: const TextStyle(
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

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         margin: EdgeInsets.all(10),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.end,
                    //           children: [
                    //             Text(
                    //               "Jul 12, 2021 10:00 AM",
                    //               style: TextStyle(
                    //                 color: Color.fromARGB(255, 100, 100, 100),
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 12,
                    //               ),
                    //             ),
                    //             Container(
                    //               padding: EdgeInsets.all(10),
                    //               margin: EdgeInsets.only(top: 5),
                    //               decoration: BoxDecoration(
                    //                 color: Theme.of(context).primaryColor,
                    //                 borderRadius: BorderRadius.circular(10),
                    //               ),
                    //               child: Text(
                    //                 'I need help with my account. I am unable to login. I have tried resetting my password but it is not working.',
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         margin: EdgeInsets.all(10),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Jul 12, 2021 10:00 AM",
                    //               style: TextStyle(
                    //                 color: Color.fromARGB(255, 100, 100, 100),
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 12,
                    //               ),
                    //             ),
                    //             Container(
                    //               padding: EdgeInsets.all(10),
                    //               margin: EdgeInsets.only(top: 5),
                    //               decoration: BoxDecoration(
                    //                 color: Color.fromARGB(255, 49, 49, 49),
                    //                 borderRadius: BorderRadius.circular(10),
                    //               ),
                    //               child: Text(
                    //                 'Please provide me with your email address.',
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // bottom buttons
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _inputController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 17, 20, 27),
                      hintText: 'Ask a anything...',
                      prefixStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 54, 54, 54), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 68, 68, 68), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    generateMessage();
                  },
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
