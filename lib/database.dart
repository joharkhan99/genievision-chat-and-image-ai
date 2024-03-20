import 'dart:convert';
import 'package:genievision/message_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Database {
  // reference box
  final msgBox = Hive.box('chatMessages');

  // Database() {
  //   msgBox.deleteAll(msgBox.keys);
  // }

  List<Message> loadMessages() {
    final chatMessages = <Message>[];
    for (var i = 0; i < msgBox.length; i++) {
      final message = Message.fromJson(jsonDecode(msgBox.getAt(i)));
      chatMessages.add(message);
    }
    return chatMessages;
  }

  void saveData(Message message) {
    msgBox.add(jsonEncode(message));
  }

  List<Content> getHistory() {
    List<Content> history = [];
    for (var i = 0; i < msgBox.length; i++) {
      final message = Message.fromJson(jsonDecode(msgBox.getAt(i)));
      if (message.sender == 'user') {
        history.add(Content.text(message.text));
      } else {
        history.add(Content.model([TextPart(message.text)]));
      }
    }
    if (history.isEmpty) {
      history = [
        Content.text('Hello, I have 2 dogs in my house.'),
        Content.model([TextPart('Great to meet you. What would you like to know?')])
      ];
    }
    return history;
  }
}
