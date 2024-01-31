import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/home.dart';
import 'package:ebook/view_page.dart';
import 'package:ebook/widget/keypad.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'banner_ad.dart';
import 'diary_entry.dart';
import 'guest_update.dart';
import 'settings.dart';

class IndexScreen extends StatefulWidget {
  final String userId; // The id of the current user

  const IndexScreen({super.key, required this.userId});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

DateTime? _selectedDate;

class _IndexScreenState extends State<IndexScreen> {
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Set<DateTime> uniqueId = <DateTime>{};

  bool permission = false;

  String? userId = FirebaseAuth.instance.currentUser!.uid;

  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  void _getPermission() async {
    final grant = await Permission.notification.request().isGranted;
    setState(() {
      permission = grant;
    });
  }

  @override
  void initState() {
    MobileAds.instance.initialize();
    _getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        iconTheme: const IconThemeData(
          color: Color(0xFF4E352A),
        ),
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          key: _key,
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0XFFC8AE7D),
            child: Image.asset(
              'assets/pen2.png',
              height: 43,
              width: 43,
              color: Colors.brown,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DiaryEntryScreen();
                  });
            },
          ),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: const SizedBox(
            height: 50.0,
            child: BannerAdWidget(),
          ),
          drawer: Drawer(
            backgroundColor: const Color(0XFFEEE3CB),
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0XFFC8AE7D),
                  ), //BoxDecoration
                  child: UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Color(0XFFC8AE7D)),
                    accountEmail: const SizedBox(height: 0),
                    accountName: Text(
                        FirebaseAuth.instance.currentUser!.email == ""
                            ? "Guest"
                            : FirebaseAuth.instance.currentUser!.email ??
                                "Guest"),
                    currentAccountPictureSize: const Size.square(40),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.brown,
                      child: Text(
                        FirebaseAuth.instance.currentUser!.email == ""
                            ? "G"
                            : FirebaseAuth.instance.currentUser!.email != null
                                ? FirebaseAuth.instance.currentUser!.email![0]
                                : "G",
                        style: const TextStyle(
                            fontSize: 25.0, color: Colors.white),
                      ), //Text
                    ), //circleAvatar
                  ), //UserAccountDrawerHeader
                ), //DrawerHeader
                if (FirebaseAuth.instance.currentUser!.email == "" ||
                    FirebaseAuth.instance.currentUser!.email == null)
                  ListTile(
                    leading: const Icon(Glyphicon.person),
                    title: const Text(
                      ' Sign up ',
                      style: TextStyle(color: Color(0xFF4E352A)),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GuestUpdateScreen()));
                    },
                  ),
                ListTile(
                  leading: const Icon(Glyphicon.gear),
                  title: const Text(
                    ' Settings ',
                    style: TextStyle(color: Color(0xFF4E352A)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    //Get.to(const SettingsPage());
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Glyphicon.box_arrow_right),
                  title: const Text(
                    'LogOut',
                    style: TextStyle(color: Color(0xFF4E352A)),
                  ),
                  onTap: _showlogoutDialog,
                ),
                ListTile(
                  leading: const Icon(Glyphicon.star),
                  title: const Text(
                    'Rate us ',
                    style: TextStyle(color: Color(0xFF4E352A)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Glyphicon.share),
                  title: const Text(
                    'Share app',
                    style: TextStyle(color: Color(0xFF4E352A)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.example.myapp');
                  },
                ),
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(left: 25, right: 25),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/retro.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconStyle1(
                        icon: GestureDetector(
                          child: const Icon(Icons.menu),
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                        ),
                      ),
                      _selectedDate != null
                          ? Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color(0XFFC8AE7D),
                                border: Border.all(
                                  color: const Color(0XFFC8AE7D),
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                boxShadow: kElevationToShadow[4],
                              ),
                              child: Row(children: [
                                Text(
                                    "   ${months[_selectedDate!.month - 1]}, ${_selectedDate!.year}  "),
                                Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFC8AE7D),
                                      border: Border.all(
                                        color: const Color(0XFFC8AE7D),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      boxShadow: kElevationToShadow[4],
                                    ),
                                    child: GestureDetector(
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedDate = null;
                                        });
                                      },
                                    ))
                              ]))
                          : SizedBox(),
                      IconStyle1(
                        icon: GestureDetector(
                          child: const Icon(Icons.edit_calendar),
                          onTap: () {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildCupertinoDatePicker(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Index",
                  style: GoogleFonts.signika(
                    textStyle: const TextStyle(
                      fontSize: 45,
                      color: Color(0xFF4E352A), // Deep brown or sepia color
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: Colors.brown,
                            style: BorderStyle.solid),
                        color: Colors.transparent),
                    child: Center(
                      child: Text(
                        'Create new entry',
                        //style: GoogleFonts.openSans(
                        //style: GoogleFonts.montserrat(
                        style: GoogleFonts.montserrat(
                          //shadows: [
                          //  Shadow(
                          //    color: Colors.grey[600]!,
                          //    blurRadius: 6,
                          //  ),
                          //],
                          //style: GoogleFonts.nunito(
                          //style: GoogleFonts.signika(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: Color(0xFF4E352A)),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const DiaryEntryScreen();
                        });
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore
                        .instance // Get an instance of Firestore
                        .collection('users') // Get the users collection
                        .doc(userId) // Get the document for the current user
                        .collection(
                            'diaryEntries') // Get the entries subcollection for the user
                        .orderBy('timestamp',
                            descending:
                                true) // Order the documents by date in descending order
                        .snapshots(), // Get a stream of query snapshots
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        uniqueId.clear();
                        // If the snapshot has data, display it in a list view
                        List<DocumentSnapshot> documents = snapshot.data!
                            .docs; // The list of documents in the snapshot
                        if (_selectedDate != null) {
                          // If there is a selected month and year, filter the documents by matching them with the date field
                          documents = documents.where((document) {
                            DateTime date = document['timestamp']
                                .toDate(); // Get the date field as a DateTime object
                            return date.month ==
                                    _selectedDate!
                                        .month && // Check if the month matches
                                date.year ==
                                    _selectedDate!
                                        .year; // Check if the year matches
                          }).toList();
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 8.0),
                          itemCount: documents
                              .length, // The number of filtered documents
                          itemBuilder: (context, index) {
                            // For each document, display its date in a list tile
                            DocumentSnapshot document = documents[
                                index]; // Get the document at the index
                            DateTime date = document['timestamp']
                                .toDate(); // Get the date field as a DateTime object
                            date = DateTime(date.year, date.month, date.day);
                            bool unique = !uniqueId.contains(date);
                            uniqueId.add(date);
                            if (unique) {
                              return GestureDetector(
                                child: ListTile(
                                  leading: const Icon(
                                    FontAwesomeIcons.bookmark,
                                    color: Colors.brown,
                                    size: 16,
                                  ),
                                  title: Text(
                                    formatDate(date),
                                    //style: GoogleFonts.cinzel(
                                    //style: GoogleFonts.dancingScript(
                                    //style: GoogleFonts.greatVibes(
                                    //style: GoogleFonts.unicaOne(
                                    //style: GoogleFonts.leckerliOne(
                                    //style: GoogleFonts.montserrat(
                                    style: GoogleFonts.raleway(
                                      /*  shadows: [
                                        Shadow(
                                          color: Colors.grey[600]!,
                                          blurRadius: 7,
                                        ),
                                      ],
                                      */
                                      fontSize: 17,
                                      color: const Color(0xFF4E352A),
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.brown,
                                    size: 16,
                                  ),
                                ),
                                onTap: () {
                                  Get.to(ViewEntry(
                                    date: date,
                                  ));
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      } else if (snapshot.hasError) {
                        // If the snapshot has an error, display it in a text widget
                        return Text(snapshot.error.toString());
                      } else {
                        // Otherwise, display a circular progress indicator while waiting for data
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 160.0),
                            child: SpinKitPouringHourGlassRefined(
                              color: Colors.brown,
                              size: 50.0,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _showlogoutDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.brown[50],
        title: const Text('Are you sure?'),
        content: const Text('Your data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.brown),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.brown),
            ),
          ),
        ],
      ),
    );
    if (result == true) {
      await _logoutUser();
      Get.back();
    }
  }

  Future<void> _logoutUser() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();

      // Print a confirmation message
      print("User signed out!");
    } catch (e) {
      // Handle any errors
      print(e);
    }
    Get.off(const LoginScreen2());
  }

  Widget _buildCupertinoDatePicker(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            GestureDetector(
              onTap: () {
                _selectedDate ??= DateTime.now();
                setState(() {});
                Get.back();
              },
              child: Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0XFFC8AE7D), width: 3),
                  image: const DecorationImage(
                    image: AssetImage('assets/retro.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Icon(Icons.check, size: 20, color: Colors.brown[300]),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0XFFC8AE7D), width: 3),
                  image: const DecorationImage(
                    image: AssetImage('assets/retro.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.brown[300],
                ),
              ),
            )
          ]),
          const Row(
            children: [
              SizedBox(
                height: 5,
              )
            ],
          ),
          Container(
            height: 220,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/retro.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle:
                      TextStyle(color: Colors.brown, fontSize: 18),
                ),
              ),
              child: CupertinoDatePicker(
                backgroundColor: Colors.transparent,
                mode: CupertinoDatePickerMode.monthYear,
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  _selectedDate = newDate;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
