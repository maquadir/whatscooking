import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:whatscooking/base/whatscooking_basewidget.dart';
import 'package:whatscooking/services/firebase_auth.dart';

import '../utils.dart';
import 'home_page.dart';

class LoginPage extends WhatsCookingBase {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends WhatsCookingBaseState<LoginPage> {
  String initialCountry = 'AU';
  PhoneNumber number = PhoneNumber(isoCode: 'AU');
  final TextEditingController controller = TextEditingController();
  String userName = "";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Buyer App",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 50),
              const Text(
                "Sing in using phone number",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    this.number = number;
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  formatInput: false,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: const OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (number.phoneNumber == null) {
                      Utils.showToast('Please enter a phone number');
                      return;
                    }
                    verifyPhoneNumber();
                  },
                  child: const Text("Sign in")),
              const SizedBox(height: 10),
              const SizedBox(
                height: 20,
              ),
              //google sign in not in use for now
              // const Text("Or"),
              // const SizedBox(
              //   height: 20,
              // ),
              // GoogleSignInButton(
              //     onPressed: () {
              //       FirebaseService().signInWithGoogle().whenComplete(() {
              //         Route route =
              //             MaterialPageRoute(builder: (context) => MyHomePage());
              //         Navigator.pushReplacement(context, route);
              //       });
              //     },
              //     darkMode: true),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber:
          number.dialCode.toString() + ' ' + number.parseNumber().toString(),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Sign the user in (or link) with the auto-generated credential
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          Utils.showToast('The provided phone number is not valid.');
        } else {
          Utils.showToast(e.message.toString());
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        displayCodePrompt(context, verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void displayCodePrompt(BuildContext context, String verificationId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          String userData = "";
          return AlertDialog(
            title: const Text("Please enter code"),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("OTP Code"),
                      TextFormField(
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a code';
                          }
                          userData = value;
                        },
                        keyboardType: TextInputType.name,
                      )
                    ]),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: userData);

                    // Sign the user in (or link) with the credential
                    Navigator.of(context).pop();
                    FirebaseService()
                        .signInWithCredential(credential)
                        .whenComplete(() {
                      Route route =
                          MaterialPageRoute(builder: (context) => MyHomePage());
                      Navigator.pushReplacement(context, route);
                    });
                  }
                },
              )
            ],
          );
        });
  }
}
