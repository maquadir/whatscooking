import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatscooking/models/orders.dart';

import 'chat_view.dart';

class Chat extends StatefulWidget {
  final Order order;

  const Chat({Key? key, required this.order}) : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: ChatPage(order: widget.order)));
  }
}
