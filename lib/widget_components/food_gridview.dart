import 'package:flutter/material.dart';
import 'package:whatscooking/widget_components/food_thumbnail.dart';

import '../models/food.dart';


class FoodGridView extends StatelessWidget {

  final List<Food> foodList;

  const FoodGridView({Key? key, required this.foodList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 6,
          right: 6,
          top: 6
      ),
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: foodList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2), itemBuilder: (context, index) {
        final food = foodList[index];
        return FoodThumbnail(food: food);
      }),
    );
  }

}