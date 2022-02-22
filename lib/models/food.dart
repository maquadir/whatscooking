import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String userName;
  final String dishName;
  final String imageUrl;
  final String cuisine;
  final String suburb;
  final String? poCode;
  final String price;
  final String foodType;
  final String? uid;

  const Food(
      {required this.userName,
      required this.dishName,
      required this.imageUrl,
      required this.cuisine,
      required this.suburb,
      required this.poCode,
      required this.price,
      required this.foodType,
      required this.uid});

  static Food fromJson(Map<String, dynamic> json) => Food(
        userName: json['user_name'] ?? "",
        dishName: json['dish_name'] ?? "",
        imageUrl: json['imageUrl'] ?? "",
        cuisine: json['cuisine'] ?? "",
        suburb: json['suburb'] ?? "",
        poCode: json['po_code'] ?? "",
        price: json['price'] ?? "",
        foodType: json['food_type'] ?? "",
        uid: json['uid'] ?? "",
      );

  static List<Food> empty() => List<Food>.empty();
}
