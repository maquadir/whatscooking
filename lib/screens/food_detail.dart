import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:whatscooking/api/firebase_api.dart';
import 'package:whatscooking/base/whatscooking_basewidget.dart';
import 'package:whatscooking/models/profile.dart';
import 'package:whatscooking/services/send_notification_service.dart';
import '../models/food.dart';
import '../utils.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FoodDetail extends WhatsCookingBase {
  final Food food;

  const FoodDetail({Key? key, required this.food}) : super(key: key);

  @override
  FoodDetailState createState() => FoodDetailState();
}

class FoodDetailState extends WhatsCookingBaseState<FoodDetail> {
  String formattedDate = "";

  @override
  void initState() {
    super.initState();

    //for push notif

    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);
    // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //
    //   // If `onMessage` is triggered with a notification, construct our own
    //   // local notification to show to users using the created channel.
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             icon: android.smallIcon,
    //             // other properties...
    //           ),
    //         ));
    //   }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title.toString()),
    //             content: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text(notification.body.toString())],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final String buyForAmount = "Buy for ${widget.food.price}";

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.food.dishName),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 330,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.food.imageUrl),
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Dish name",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.food.dishName,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Cuisine",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.food.cuisine,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Suburb",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.food.suburb,
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      style: style,
                      onPressed: () async {
                        formattedDate =
                            Utils.getTodaysDate('kk:mm:ss , dd/MM/yyyy');
                        Utils.loadUserProfileFromPrefs().then((profile) => {
                              if (Profile.isValid(profile))
                                {
                                  Utils.showToast(
                                      "Order placed. Please check Orders"),
                                  FirebaseApi.addOrder(widget.food, user,
                                      profile, formattedDate),
                                  FirebaseApi.sendFCM(
                                      widget.food, profile, formattedDate)
                                }
                              else
                                {
                                  Utils.showToast(
                                      "Please complete your profile in order to proceed")
                                }
                            });
                      },
                      child: new Text(buyForAmount))
                ]))));
  }
}
