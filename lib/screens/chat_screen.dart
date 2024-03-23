import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final ScrollController _scrollController = ScrollController();

  List<Message> chatMessages = [];
  String apiKey = "AIzaSyBqbJzQPpcZTkJJARtW02EiSWW8GFJpDe0";
  late GenerativeModel model;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // scroll to bottom
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 300), // Adjust duration as needed
    //   curve: Curves.easeOut,
    // );

    chatMessages = Database().loadMessages();
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey, generationConfig: GenerationConfig(maxOutputTokens: 500));
  }

  String getDate(DateTime dateTime) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} ${dateTime.hour}:${dateTime.minute} ${dateTime.hour > 12 ? "PM" : "AM"}";
  }

  Future<void> generateMessage() async {
    if (_inputController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

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
    print(response);
    print(response.text);

    Message responseMessage = Message();
    responseMessage.sender = 'genie';
    responseMessage.time = getDate(DateTime.now());
    responseMessage.text = response.text!;
    Database().saveData(responseMessage);

    setState(() {
      chatMessages = Database().loadMessages();
      _isLoading = false;
    });
    _inputController.clear();
    // scroll to bottom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void copyToClipboard(String text) async {
    // copy text to clipboard
    await Clipboard.setData(ClipboardData(text: text));

    const snackBar = SnackBar(
      content: Text("Text copied to Clipboard"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      color: const Color.fromARGB(255, 17, 20, 27),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatMessages.length,
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                return chatMessages[index].sender == 'user'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // icon button for copy
                                      IconButton(
                                        color: Colors.red,
                                        padding: const EdgeInsets.all(0),
                                        alignment: Alignment.centerRight,
                                        onPressed: () => copyToClipboard(chatMessages[index].text),
                                        icon: const Icon(
                                          Icons.copy_rounded,
                                          color: Color.fromARGB(255, 100, 100, 100),
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        chatMessages[index].time,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 100, 100, 100),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(top: 5, bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      chatMessages[index].text,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        chatMessages[index].time,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 100, 100, 100),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      IconButton(
                                        color: Colors.red,
                                        constraints: const BoxConstraints.tightForFinite(),
                                        padding: const EdgeInsets.all(0),
                                        alignment: Alignment.centerRight,
                                        onPressed: () => copyToClipboard(chatMessages[index].text),
                                        icon: const Icon(
                                          Icons.copy_rounded,
                                          color: Color.fromARGB(255, 100, 100, 100),
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 49, 49, 49),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      chatMessages[index].text,
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
                      );
              },
            ),
          ),

          _isLoading
              ? const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : const SizedBox.shrink(),

          // bottom buttons
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: TextField(
                      enabled: !_isLoading,
                      controller: _inputController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 17, 20, 27),
                        hintText: 'Ask me anything...',
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _isLoading ? null : generateMessage();
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
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
