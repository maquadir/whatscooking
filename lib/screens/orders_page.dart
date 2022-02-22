import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatscooking/api/firebase_api.dart';
import 'package:whatscooking/base/whatscooking_basewidget.dart';
import 'package:whatscooking/models/orders.dart';

import 'chat.dart';

class Orders extends WhatsCookingBase {
  const Orders({Key? key}) : super(key: key);

  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends WhatsCookingBaseState<Orders> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: FirebaseApi.getOrders(user),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        final List<int> colorCodes = <int>[600, 500, 100];
        var orders = snapshot.data ?? Order.empty();

        return (orders.length > 0
            ? ListView.separated(
                padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  var order = orders[index];
                  return Column(children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chat(order: order)),
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber[colorCodes[index]],
                              boxShadow: const [
                                BoxShadow(color: Colors.black, spreadRadius: 1),
                              ],
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Order placed for ${order.dishName} from ${order.seller}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("Address: ${order.suburb}",
                                      style: const TextStyle(fontSize: 17)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("At: ${order.dateTime}",
                                      style: const TextStyle(fontSize: 17)),
                                ],
                              ),
                            )))
                  ]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )
            : const Center(
                child: Text(
                "You currently have not placed any order",
                style: TextStyle(fontSize: 22),
              )));
      },
    );
  }
}
