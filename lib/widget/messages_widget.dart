import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatscooking/api/firebase_api.dart';
import 'package:whatscooking/base/whatscooking_basewidget.dart';
import 'package:whatscooking/models/message.dart';

import 'message_widget.dart';

class MessagesWidget extends WhatsCookingBase {
  final String sellerUid;
  final String dishName;

  const MessagesWidget({
    required this.sellerUid,
    required this.dishName,
    Key? key,
  }) : super(key: key);

  @override
  MessagesWidgetState createState() => MessagesWidgetState();
}

class MessagesWidgetState extends WhatsCookingBaseState<MessagesWidget> {
  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(widget.sellerUid, widget.dishName),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data!;

                return messages.isEmpty
                    ? buildText('Chat about your order..')
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return MessageWidget(
                            message: message,
                            isMe: message.uid == user!.uid,
                          );
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
