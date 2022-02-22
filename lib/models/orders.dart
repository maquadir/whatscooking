import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String buyer;
  final String buyerUid;
  final String cuisine;
  final String dateTime;
  final String dishName;
  final String foodType;
  final String imageUrl;
  final String price;
  final String seller;
  final String sellerUid;
  final String suburb;

  const Order(
      {required this.buyer,
      required this.buyerUid,
      required this.cuisine,
      required this.dateTime,
      required this.dishName,
      required this.foodType,
      required this.imageUrl,
      required this.price,
      required this.seller,
      required this.sellerUid,
      required this.suburb
      });

  static Order fromJson(Map<String, dynamic> json) => Order(
        buyer: json['buyer'] ?? "",
        buyerUid: json['buyer_uid'] ?? "",
        cuisine: json['cuisine'] ?? "",
        dateTime: json['dateTime'] ?? "",
        dishName: json['dish_name'] ?? "",
        foodType: json['food_type'] ?? "",
        imageUrl: json['imageUrl'] ?? "",
        price: json['price'] ?? "",
        seller: json['seller'] ?? "",
        sellerUid: json['seller_uid'] ?? "",
        suburb: json['suburb'] ?? ""
      );

  static List<Order> empty() => List<Order>.empty();
}
