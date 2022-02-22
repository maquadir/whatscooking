import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whatscooking/api/firebase_api.dart';
import 'package:whatscooking/models/profile.dart';

class WhatsCookingBase extends StatefulWidget {
  const WhatsCookingBase({Key? key}) : super(key: key);

  @override
  WhatsCookingBaseState createState() => WhatsCookingBaseState();
}

class WhatsCookingBaseState<T extends WhatsCookingBase> extends State<T> {
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void initFirebase() {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
    FirebaseFirestore.instance.clearPersistence();
    user = FirebaseAuth.instance.currentUser;
  }


}
