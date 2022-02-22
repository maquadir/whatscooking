import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whatscooking/api/firebase_api.dart';
import 'package:whatscooking/base/whatscooking_basewidget.dart';
import 'package:whatscooking/models/profile.dart';
import 'package:whatscooking/services/firebase_auth.dart';
import 'package:whatscooking/services/location.dart';

import '../utils.dart';
import 'login_page.dart';

class ProfilePage extends WhatsCookingBase {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends WhatsCookingBaseState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String userName = "";
  String suburb = "";
  String poCode = "";

  void initState() {
    super.initState();
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

          final profile = snapshot.data!;

          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    const Text(
                      "Profile",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            key: UniqueKey(),
                            decoration: const InputDecoration(
                                icon: Icon(Icons.person),
                                hintText: 'Please enter your name',
                                labelText: "Name"),
                            initialValue: profile.userName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              profile.userName = value;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            key: UniqueKey(),
                            decoration: const InputDecoration(
                                icon: Icon(Icons.location_city),
                                hintText: 'Please enter your suburb',
                                labelText: "Suburb"),
                            initialValue: profile.suburb,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your suburb';
                              }
                              profile.suburb = value;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            key: UniqueKey(),
                            decoration: const InputDecoration(
                                icon: Icon(Icons.add_location),
                                hintText: 'Please enter your post code',
                                labelText: "PO Code"),
                            initialValue: profile.poCode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your post code';
                              }
                              profile.poCode = value;
                            },
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            key: UniqueKey(),
                            decoration: const InputDecoration(
                                icon: Icon(Icons.flag),
                                hintText: 'Please enter your country',
                                labelText: "Country"),
                            initialValue: profile.country,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your country';
                              }
                              profile.country = value;
                            },
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            Utils.storeUserDataInSharedPreferences(profile);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saving data')),
                            );
                            FirebaseApi.updateProfileToFireBase(user, profile);
                          }
                        },
                        child: const Text("Save")),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Utils.clearPrefs();
                          FirebaseService()
                              .signOutFromGoogle()
                              .whenComplete(() {
                            Route route = MaterialPageRoute(
                                builder: (context) => LoginPage());
                            Navigator.pushReplacement(context, route);
                          });
                        },
                        child: const Text("Sign out"))
                  ],
                ),
              )));
        });
  }
}
