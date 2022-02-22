import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:whatscooking/screens/home_page.dart';
import 'package:whatscooking/screens/login_page.dart';
import 'services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(() => checkUser());
}

void checkUser() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    runApp(MyHomePage());
  } else {
    runApp(WhatsCooking());
  }
}

class WhatsCooking extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Navigation Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage());
  }
}
