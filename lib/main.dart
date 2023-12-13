import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/widget/keypad.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final Controller c = Get.put(Controller(), permanent: true);
  bool lockEnabled = prefs.getBool('lockEnabled') ?? false;
  c.password = prefs.getString('password');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  runApp(
    GetMaterialApp(
      home: AppLock(
        builder: (arg) => MyApp(data: arg),
        lockScreen: const LockScreen(),
        enabled: lockEnabled,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key, Object? data});
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      // Navigate to the home page
      return const MaterialApp(home: IndexScreen(userId: ""));
    } else {
      // Navigate to the login page
      return const LoginScreen2();
    }
  }
}

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  LockScreenState createState() => LockScreenState();
}

class LockScreenState extends State<LockScreen> {
  final TextEditingController t0 = TextEditingController(text: "0");
  final TextEditingController t1 = TextEditingController(text: "0");
  final TextEditingController t2 = TextEditingController(text: "0");
  final TextEditingController t3 = TextEditingController(text: "0");
  List<Widget> numbers = [
    const KeyPad(num: "0"),
    const KeyPad(num: "1"),
    const KeyPad(num: "2"),
    const KeyPad(num: "3"),
    const KeyPad(num: "4"),
    const KeyPad(num: "5"),
    const KeyPad(num: "6"),
    const KeyPad(num: "7"),
    const KeyPad(num: "8"),
    const KeyPad(num: "9"),
  ];

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
              Text(
                "Memoir",
                style: GoogleFonts.yesteryear(
                  textStyle: const TextStyle(
                    fontSize: 55,
                    color: Color(0xFF4E352A), // Deep brown or sepia color
                  ),
                ),
              ),
              const SizedBox(height: 160),
              Text(
                'Enter the password to unlock',
                style: GoogleFonts.signika(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF4E352A), // Deep brown or sepia color
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0XFFC8AE7D), width: 3),
                    image: const DecorationImage(
                      image: AssetImage('assets/retro.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KeyBox(
                        box: CupertinoPicker(
                          looping: true,
                          magnification: 1.22,
                          squeeze: 1.0,
                          useMagnifier: true,
                          backgroundColor: Colors.transparent,
                          itemExtent: 30,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          children: numbers,
                          onSelectedItemChanged: (value) {
                            t0.text = value.toString();
                            setState(() {});
                          },
                        ),
                      ),
                      KeyBox(
                        box: CupertinoPicker(
                          looping: true,
                          magnification: 1.22,
                          squeeze: 1.0,
                          useMagnifier: true,
                          backgroundColor: Colors.transparent,
                          itemExtent: 30,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          children: numbers,
                          onSelectedItemChanged: (value) {
                            t1.text = value.toString();
                            setState(() {});
                          },
                        ),
                      ),
                      KeyBox(
                        box: CupertinoPicker(
                          looping: true,
                          magnification: 1.22,
                          squeeze: 1.0,
                          useMagnifier: true,
                          backgroundColor: Colors.transparent,
                          itemExtent: 30,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          children: numbers,
                          onSelectedItemChanged: (value) {
                            t2.text = value.toString();
                            setState(() {});
                          },
                        ),
                      ),
                      KeyBox(
                        box: CupertinoPicker(
                          looping: true,
                          magnification: 1.22,
                          squeeze: 1.0,
                          useMagnifier: true,
                          backgroundColor: Colors.transparent,
                          itemExtent: 30,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          children: numbers,
                          onSelectedItemChanged: (value) {
                            t3.text = value.toString();
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconStyle(
                icon: GestureDetector(
                  child: const Icon(Icons.lock),
                  onTap: () {
                    final Controller c = Get.find<Controller>();
                    if (t0.text == c.password![0] &&
                        t1.text == c.password![1] &&
                        t2.text == c.password![2] &&
                        t3.text == c.password![3]) {
                      // Unlock the app with some data
                      AppLock.of(context)!.didUnlock('Hello world');
                    } else {
                      // Show an error message
                      Get.snackbar("", "Wrong password",
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
