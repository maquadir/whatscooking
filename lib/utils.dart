import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/profile.dart';

class Utils {
  static Future<void> storeUserDataInSharedPreferences(Profile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', profile.userName);
    prefs.setString('suburb', profile.suburb);
    prefs.setString('post_code', profile.poCode);
    prefs.setString('country', profile.country);
  }

  static Future<Profile> loadUserProfileFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('user_name') ?? "";
    var poCode = prefs.getString('post_code') ?? "";
    var suburb = prefs.getString('suburb') ?? "";
    var country = prefs.getString('country') ?? "";
    Profile profile =
        Profile(userName: username, suburb: suburb, poCode: poCode, country: country);
    return profile;
  }

  static Future<void> clearPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static Future<void> showAlertDialog(
      String title, String message, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      listTransformer<T>(T Function(Map<String, dynamic> json) fromJson) =>
          StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
              List<T>>.fromHandlers(
            handleData: (QuerySnapshot<Map<String, dynamic>> data,
                EventSink<List<T>> sink) {
              final snaps = data.docs.map((doc) => doc.data()).toList();
              final users = snaps.map((json) => fromJson(json)).toList();

              sink.add(users);
            },
          );

  static StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
      T> streamTransformer<T>(
          T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<DocumentSnapshot<Map<String, dynamic>>, T>.fromHandlers(
          handleData: (DocumentSnapshot<Map<String, dynamic>> data, sink) {
        sink.add(fromJson(data.data() ?? {}));
      });

  static DateTime toDateTime(Timestamp value) {
    // if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static String getTodaysDate(String format) =>
      DateFormat(format).format(DateTime.now());
}
