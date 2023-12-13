// Import the necessary packages
import 'package:ebook/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';
import 'signup.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bl.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Login button
              Text(
                "Memoir",
                style: GoogleFonts.yesteryear(
                  textStyle: const TextStyle(
                    fontSize: 55,
                    color: Color(0xFF4E352A), // Deep brown or sepia color
                  ),
                ),
              ),
              const SizedBox(height: 120),
              InkWell(
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Colors.brown,
                          style: BorderStyle.solid),
                      color: Colors.transparent),
                  child: Center(
                    child: Text(
                      'Login',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF4E352A)),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(const LoginScreen());
                },
              ),
              const SizedBox(height: 16.0),
              InkWell(
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Colors.brown,
                          style: BorderStyle.solid),
                      color: Colors.transparent),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF4E352A)),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(const SignUpScreen());
                },
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Colors.brown,
                          style: BorderStyle.solid),
                      color: Colors.transparent),
                  child: Center(
                    child: Text(
                      'Google Sign Up',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF4E352A)),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  signInWithGoogle();
                },
              ),
              const SizedBox(height: 150.0),
              GestureDetector(
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Colors.brown,
                          style: BorderStyle.solid),
                      color: Colors.transparent),
                  child: Center(
                    child: Text(
                      'Login as Guest',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF4E352A)),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  try {
                    final userCredential =
                        await FirebaseAuth.instance.signInAnonymously();
                    print("Signed in with temporary account.");

                    //Get.off(const IndexScreen(userId: '',));
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const IndexScreen(
                              userId: '',
                            )));
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case "operation-not-allowed":
                        print(
                            "Anonymous auth hasn't been enabled for this project.");
                        break;
                      default:
                        print("Unknown error.");
                    }
                  }
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      // Get the GoogleSignInAccount
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign in, return
      if (googleUser == null) return;

      // Get the GoogleSignInAuthentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential with the idToken and accessToken
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in the user with the credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Get the User object
      final User user = userCredential.user!;

      // Display a welcome message
      Get.off(const IndexScreen(
        userId: '',
      ));
      Get.snackbar("", "Welcome, ${user.displayName}!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Handle any errors
      print(e);
      Get.snackbar("", "Something went wrong!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
