
import 'package:flutter/material.dart';
import 'package:whatscooking/models/orders.dart';
import 'package:whatscooking/widget/messages_widget.dart';
import 'package:whatscooking/widget/new_message_widget.dart';
import 'package:whatscooking/widget/profile_header_widget.dart';

class ChatPage extends StatefulWidget {
  final Order order;

  const ChatPage({
    required this.order,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.order.seller),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(sellerUid: widget.order.buyerUid, dishName: widget.order.dishName,),
                ),
              ),
              NewMessageWidget(order: widget.order)
            ],
          ),
        ),
      );
}
