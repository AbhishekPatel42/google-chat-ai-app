import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mychat extends StatefulWidget {
  const Mychat({super.key});

  @override
  State<Mychat> createState() => _MychatState();
}

class _MychatState extends State<Mychat> {
  List<ChatMessage> allMessges = [];
  final oururl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDYh6P8JLoV3lTb63ks6zqvB1JEcHEpZEo';

  final header = {'Content-Type': 'application/json'};

  ChatUser myself = ChatUser(id: '1', firstName: 'Abhishek');
  ChatUser bot = ChatUser(id: '2', firstName: 'Gamini');
  getdat(ChatMessage m) async {
    allMessges.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(oururl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        text:
        print(result['candidates'][0]['content']['parts'][0]['text']);
        ChatMessage m1 = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: bot,
            createdAt: DateTime.now());
        allMessges.insert(0, m1);
        setState(() {});
      } else {
        print('error occured');
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 158, 154),
        title: const Text(
          'TUDO',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
          messageOptions: const MessageOptions(
            currentUserContainerColor: Color.fromARGB(255, 233, 127, 127),
            containerColor: Color.fromARGB(255, 61, 158, 154),
            textColor: Colors.white,
          ),
          currentUser: myself,
          onSend: (ChatMessage m) {
            getdat(m);
          },
          messages: allMessges),
    );
  }
}
