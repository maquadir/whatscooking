import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatscooking/models/currentLocation.dart';
import 'package:whatscooking/models/food.dart';
import 'package:whatscooking/models/message.dart';
import 'package:whatscooking/models/orders.dart';
import 'package:whatscooking/models/profile.dart';
import 'package:whatscooking/services/send_notification_service.dart';

import '../utils.dart';

class FirebaseApi {
  static Stream<Profile> getProfile(User? user) => FirebaseFirestore.instance
      .collection('buyers')
      .doc(user?.uid.toString())
      .collection('profile_collection')
      .doc('profile_document')
      .snapshots()
      .transform(Utils.streamTransformer(Profile.fromJson));

  static Stream<List<Food>> getDishes(String? poCode) =>
      FirebaseFirestore.instance
          .collection('buyers')
          .doc(poCode)
          .collection("dishes")
          .snapshots()
          .transform(Utils.listTransformer(Food.fromJson));

  static Stream<List<Order>> getOrders(User? user) => FirebaseFirestore.instance
      .collection('buyers')
      .doc(user?.uid.toString())
      .collection('buyer_orders')
      .snapshots()
      .transform(Utils.listTransformer(Order.fromJson));

  static Future<void> updateLocation(
      CurrentLocation location, User? user) async {
    CollectionReference buyerProfile =
        FirebaseFirestore.instance.collection('buyers');
    await buyerProfile
        .doc(user!.uid.toString())
        .collection('profile_collection')
        .doc('profile_document')
        .update({
      "suburb": location.suburb,
      "po_code": location.poCode,
    });
  }

  static Stream<List<Message>> getMessages(String sellerUid, String dishName) =>
      FirebaseFirestore.instance
          .collection('chats/$sellerUid/$dishName')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.listTransformer(Message.fromJson));

  static Future<void> saveProfileToFireBase(User? user, Profile profile) async {
    CollectionReference buyerProfile =
        FirebaseFirestore.instance.collection('buyers');
    await buyerProfile
        .doc(user?.uid.toString())
        .collection('profile_collection')
        .doc('profile_document')
        .set({
      "user_name": profile.userName,
      "suburb": profile.suburb,
      "po_code": profile.poCode,
      "country": profile.country,
    });
  }

  static Future<void> updateProfileToFireBase(
      User? user, Profile profile) async {
    CollectionReference buyerProfile =
        FirebaseFirestore.instance.collection('buyers');
    await buyerProfile
        .doc(user?.uid.toString())
        .collection('profile_collection')
        .doc('profile_document')
        .update({
      "user_name": profile.userName,
      "suburb": profile.suburb,
      "po_code": profile.poCode,
      "country": profile.country,
    });
  }

  static Future uploadMessage(Order order, String message) async {
    final refMessages = FirebaseFirestore.instance
        .collection('chats/${order.buyerUid}/${order.dishName}');

    final newMessage = Message(
      uid: order.buyerUid,
      urlAvatar: "",
      username: order.buyer,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    // final refUsers = FirebaseFirestore.instance.collection('users');
    // await refUsers
    //     .doc(idUser)
    //     .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Future<void> sendFCM(
      Food food, Profile profile, String formattedDate) async {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(food.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          dynamic nested = documentSnapshot.get(FieldPath(['tokens']));
          var token = nested[0];
          print('Document data: ' + token.toString());
          Api().sendFcm(
              "Order Placed for " + food.dishName,
              "An order was placed by " +
                  profile.userName +
                  " at " +
                  formattedDate,
              token.toString());
        } on StateError catch (e) {
          print('No nested field exists!');
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  static Future<void> saveTokenToDatabase(String token, User? user) async {
    // Assume user is logged in for this example
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  static Future<void> addOrder(
      Food food, User? user, Profile profile, String formattedDate) async {
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');

    CollectionReference sellers =
        FirebaseFirestore.instance.collection('sellers');

    await buyers
        .doc(user?.uid)
        .collection('buyer_orders')
        .doc(food.dishName)
        .set({
          'dish_name': food.dishName,
          'cuisine': food.cuisine,
          'imageUrl': food.imageUrl,
          'food_type': food.foodType,
          'buyer_uid': user?.uid,
          'seller_uid': food.uid,
          'price': food.price,
          'buyer': profile.userName,
          'seller': food.userName,
          'suburb': profile.suburb,
          'dateTime': formattedDate
        })
        .then((value) => print("buyer order Added"))
        .catchError((error) => print("Failed to add user: $error"));

    await sellers
        .doc(food.uid)
        .collection('seller_orders')
        .doc(food.dishName)
        .set({
          'dish_name': food.dishName,
          'cuisine': food.cuisine,
          'imageUrl': food.imageUrl,
          'food_type': food.foodType,
          'buyer_uid': user?.uid.toString(),
          'price': food.price,
          'buyer': profile.userName,
          'seller': food.userName,
          'suburb': profile.suburb,
          'dateTime': formattedDate,
          'seller_uid': food.uid,
        })
        .then((value) => print("seller order Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
