import 'package:flutter/material.dart';
import 'package:whatscooking/screens/food_detail.dart';
import '../models/food.dart';

class FoodThumbnail extends StatelessWidget {
  final Food food;

  const FoodThumbnail({
    Key? key,
    required this.food
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetail(food: food),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(food.imageUrl),
                  ),
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text(food.dishName), Text(food.price)],
              )
            ],
          ),
        ));
  }
}
