import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatscooking/api/firebase_api.dart';
import 'package:whatscooking/base/whatscooking_basewidget.dart';
import 'package:whatscooking/models/profile.dart';
import 'package:whatscooking/screens/orders_page.dart';
import 'package:whatscooking/screens/profile_page.dart';
import 'package:whatscooking/services/location.dart';
import '../utils.dart';
import 'buy_page.dart';

class MyHomePage extends WhatsCookingBase {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends WhatsCookingBaseState<MyHomePage> {
  int currentIndex = 0;
  var userName;

  var postCode;

  List<String> titleList = ["Buy", "Sell", "Profile"];

  @override
  void initState() {
    super.initState();

    checkLocation();
  }

  void checkLocation() {
    Utils.loadUserProfileFromPrefs().then((profile) => {
    if (!Profile.isValidLocation(profile)){
        GPSLocation.getCurrentLocation().then((Position position) {
      GPSLocation.getAddressFromLatLng(position).then((profile) =>
      {
        FirebaseApi.saveProfileToFireBase(user, profile),
        Utils.storeUserDataInSharedPreferences(profile)
      });
    }).catchError((e) {
      Utils.showToast(e);
    })
      }});
  }

  getScreenFromSelectedItem(int pos) {
    switch (pos) {
      case 0:
        return new BuyFood();
      case 1:
        return new Orders();
      case 2:
        return new ProfilePage();

      default:
        return new Text("Error");
    }
  }

  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    final textTheme = Theme
        .of(context)
        .textTheme;
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            backgroundColor: colorScheme.surface,
            selectedItemColor:
            Theme
                .of(context)
                .textSelectionTheme
                .selectionColor,
            unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                label: 'Buy',
                icon: Icon(Icons.food_bank),
              ),
              const BottomNavigationBarItem(
                label: 'Orders',
                icon: Icon(Icons.sell),
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.account_box), label: 'Profile')
            ],
          ),
          body: getScreenFromSelectedItem(currentIndex),
        ));
  }
}
