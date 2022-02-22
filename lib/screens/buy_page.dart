import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whatscooking/api/firebase_api.dart';
import 'package:whatscooking/base/whatscooking_basewidget.dart';
import 'package:whatscooking/models/food.dart';
import 'package:whatscooking/models/currentLocation.dart';
import 'package:whatscooking/models/profile.dart';
import 'package:whatscooking/utils.dart';
import '../widget_components/food_gridview.dart';

class BuyFood extends WhatsCookingBase {
  const BuyFood({Key? key}) : super(key: key);

  @override
  BuyFoodState createState() => BuyFoodState();
}

class BuyFoodState extends WhatsCookingBaseState<BuyFood> {
  CurrentLocation location = CurrentLocation("", "");
  bool isValidProfile = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Profile>(
        stream: FirebaseApi.getProfile(user),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('Something went wrong. Please check back again'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...'));
          }

          var profile = snapshot.data;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Whats cooking today?"),
            ),
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (() {
                        var suburb = profile?.suburb ?? "suburb";
                        var poCode = profile?.poCode ?? "po code";
                        return "You are in $suburb , $poCode";
                      })(),
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 23,
                      onPressed: () {
                        if (profile?.suburb != null &&
                            profile?.poCode != null) {
                          showEditDialog(context, profile);
                        } else {
                          Utils.showAlertDialog("Error",
                              "Please complete profile to proceed", context);
                        }
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<List<Food>>(
                  stream: FirebaseApi.getDishes(profile?.poCode),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: const Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: const Text("Loading"));
                    }

                    var foodList = snapshot.data ?? Food.empty();

                    return Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: foodList.isNotEmpty
                            ? FoodGridView(foodList: foodList)
                            : (profile?.userName != null
                                ? Text(
                                    "Nothing is cooking today in your neighborhood",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 25),
                                  )
                                : Text(
                                    "Complete profile in order to proceed",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red),
                                  )));
                  })
            ]),
          );
        });
  }

  void showEditDialog(BuildContext context, Profile? profile) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Update location"),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        key: UniqueKey(),
                        decoration: const InputDecoration(
                            icon: Icon(Icons.add_location),
                            hintText: 'Please enter your suburb',
                            labelText: "Suburb"),
                        initialValue: profile?.suburb ?? "",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your suburb';
                          }
                          location.suburb = value;
                        },
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        key: UniqueKey(),
                        decoration: const InputDecoration(
                            icon: Icon(Icons.add_location),
                            hintText: 'Please enter your post code',
                            labelText: "PO Code"),
                        initialValue: profile?.poCode ?? "",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your post code';
                          }
                          location.poCode = value;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                      ),
                    ]),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('update'),
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // Create a PhoneAuthCredential with the code
                    FirebaseApi.updateLocation(location, user).whenComplete(
                        () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Location updated..')),
                            ));
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }
}
