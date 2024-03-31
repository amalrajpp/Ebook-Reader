import 'package:ebook/index.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ebook/firebase_helper.dart';
import 'package:ebook/validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'demo_entry.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bl.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 150,
                    width: 150,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30.0, top: 12),
                    child: Center(
                      child: Text(
                        "Retrospective",
                        style: TextStyle(
                          fontFamily: "Yesteryear",
                          fontSize: 55,
                          color: Color(0xFF4E352A), // Deep brown or sepia color
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateName(
                            name: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Name",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        TextFormField(
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 70.0),
                        _isProcessing
                            ? const SpinKitCircle(
                                color: Colors.brown,
                                size: 50.0,
                              )
                            : InkWell(
                                child: Container(
                                  width: 350,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.brown,
                                          style: BorderStyle.solid),
                                      color: Colors.transparent),
                                  child: const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Color(0xFF4E352A)),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  if (_registerFormKey.currentState!
                                      .validate()) {
                                    try {
                                      User? user = await FirebaseAuthHelper
                                          .registerUsingEmailPassword(
                                        name: _nameTextController.text,
                                        email: _emailTextController.text,
                                        password: _passwordTextController.text,
                                      );

                                      setState(() {
                                        _isProcessing = false;
                                      });

                                      if (user != null) {
                                        createDemoEntry();
                                        Get.off(const IndexScreen(
                                          userId: '',
                                        ));
                                      }
                                    } catch (e) {
                                      // Handle any errors
                                      if (e is FirebaseAuthException) {
                                        if (e.code == 'email-already-in-use') {
                                          // Show a message that the email is already in use
                                          Get.snackbar("",
                                              "This email is already in use",
                                              snackPosition: SnackPosition.TOP,
                                              duration:
                                                  const Duration(seconds: 2));
                                        }
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      _isProcessing = false;
                                    });
                                  }
                                },
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
