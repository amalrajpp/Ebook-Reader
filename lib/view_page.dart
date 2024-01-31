import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookfx/bookfx.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'diary_update.dart';
import 'splitted_text.dart';
import 'fetch_diary.dart';
import 'package:intl/intl.dart';

import 'widget/keypad.dart';

class ViewEntry extends StatefulWidget {
  final DateTime date;
  const ViewEntry({Key? key, required this.date}) : super(key: key);
  @override
  ViewEntryState createState() => ViewEntryState();
}

DateTime selectedDate = DateTime.now();
Size? size;
String? id;

class ViewEntryState extends State<ViewEntry>
    with SingleTickerProviderStateMixin {
  BookController bookController = BookController();
  final GlobalKey pageKey = GlobalKey();
  final TextStyle _textStyle = const TextStyle(
    fontFamily: 'VintageHandwrittenFont',
    fontSize: 18,
    color: Color(0xFF4E352A),
  );

  int pageIndex = 0;
  // A list map with date and text
  List<Map<String, dynamic>> dataList = [];

  List<String> entries = [];
  List<DateTime> dates = [];
  List<String> did = [];
  late AnimationController _controller;
  bool _appBarVisible = true;
  bool dateHide = false;
  String dateStyle = 'EEEE, MMMM d, yyyy';
  bool nightMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      size = Size(MediaQuery.of(context).size.width - 40,
          MediaQuery.of(context).size.height - 350);
      selectedDate = DateTime(
          widget.date.year, widget.date.month, widget.date.day, 0, 0, 0);
      await getDatas(selectedDate);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dateHide = prefs.getBool('dateHide') ?? false;
      dateStyle = prefs.getString('dateFormat') ?? 'EEEE, MMMM d, yyyy';
      //nightMode = prefs.getBool('nightMode') ?? false;
    });
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAppBarVisibility() {
    setState(() {
      _appBarVisible = !_appBarVisible;
      _appBarVisible ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -2.0),
      end: Offset.zero,
    ).animate(_controller);
    return MaterialApp(
      theme: ThemeData(
        iconTheme: const IconThemeData(
          color: Color(0xFF4E352A),
        ),
      ),
      home: Scaffold(
        body: entries.isEmpty
            ? Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/retro2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: SpinKitFadingCube(
                    color: Colors.brown,
                    size: 50.0,
                  ),
                ),
              )
            : Stack(children: [
                InkWell(
                  onTap: () => _toggleAppBarVisibility(),
                  child: BookFx(
                      currentBgColor: Colors.brown[100],
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      currentPage: (index) {
                        pageIndex = index;
                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(nightMode == true
                                ? 0.5
                                : 0), // 0 = Colored, 1 = Black & White
                            BlendMode.saturation,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/retro2.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 110), // Top margin
                                  SizedBox(
                                    height: 30,
                                    child: Text(
                                      dateHide == true
                                          ? ""
                                          : DateFormat(dateStyle)
                                              .format(dates[index]), // Date
                                      style: const TextStyle(
                                        fontFamily: 'VintageHandwrittenFont',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(
                                            0xFF4E352A), // Deep brown or sepia color
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    entries[index],
                                    style: const TextStyle(
                                      fontFamily: 'VintageHandwrittenFont',
                                      fontSize: 18,
                                      color: Color(0xFF4E352A),
                                    ),
                                  ),
                                  //const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      pageCount: entries.length,
                      lastCallBack: (index) {
                        if (index == 0) {
                          return;
                        }
                        setState(() {});
                      },
                      nextCallBack: (index) {
                        if (index == entries.length - 2) {
                          print("load next");
                          getDatas(selectedDate.add(const Duration(days: 1)));
                        }
                      },
                      nextPage: (index) {
                        pageIndex = index;
                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(nightMode == true
                                ? 0.5
                                : 0), // 0 = Colored, 1 = Black & White
                            BlendMode.saturation,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/retro2.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 110), // Top margin
                                  SizedBox(
                                    height: 30,
                                    child: Text(
                                      dateHide == true
                                          ? ""
                                          : DateFormat(dateStyle)
                                              .format(dates[index]), // Date
                                      style: const TextStyle(
                                        fontFamily: 'VintageHandwrittenFont',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(
                                            0xFF4E352A), // Deep brown or sepia color
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    entries[index],
                                    style: const TextStyle(
                                      fontFamily: 'VintageHandwrittenFont',
                                      fontSize: 18,
                                      color: Color(0xFF4E352A),
                                    ),
                                  ),
                                  //const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      controller: bookController),
                ),
                SlideTransition(
                  position: offsetAnimation,
                  child: _appBarWidget,
                ),
              ]),
      ),
    );
  }

  Future<void> getDatas(DateTime entryDate) async {
    List<String> split = [];
    List<DocumentSnapshot<Object?>> diaryEntry =
        await fetchDataBetweenDates(entryDate);
    String content = "";
    if (diaryEntry.isEmpty) {
      print("No data available for the specified date range.");
      // You can also display a message to the user.
    } else {
      // Process the fetched documents
      for (var document in diaryEntry) {
        id = document.id;
        content = (document["content"]);
        // Access data from the document
        split = getSplittedText(size!, _textStyle, content);
        entries.addAll(split);

        selectedDate = document["timestamp"].toDate();
        dates.addAll(List.generate(split.length, (_) => selectedDate));
        did.addAll(List.generate(split.length, (_) => id!));
        dataList.add({'content': content, 'id': id});
      }
    }
    setState(() {});
  }

  Widget get _appBarWidget {
    return Transform.translate(
      offset: const Offset(0, 20.0),
      child: Card(
        elevation: 5,
        color: const Color(0XFFC8AE7D),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0), // 0 = Colored, 1 = Black & White
            BlendMode.saturation,
          ),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/retro2.jpg'),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 190,
                  child: Text(
                    "  Retrospective",
                    style: GoogleFonts.yesteryear(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        color: Color(0xFF4E352A), // Deep brown or sepia color
                      ),
                    ),
                  ),
                ),
                IconStyle2(
                  icon: GestureDetector(
                    child: const Icon(Icons.delete, size: 20),
                    onTap: _showDeleteDialog,
                  ),
                ),
                IconStyle2(
                  icon: GestureDetector(
                    child: const Icon(Icons.edit, size: 20),
                    onTap: () async {
                      var edit = dataList.firstWhere(
                          (element) => element['id'] == did[pageIndex]);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DiaryUpdateScreen(
                                text: edit['content'],
                                entrydate: dates[pageIndex],
                                did: did[pageIndex]);
                          });
                    },
                  ),
                ),
                IconStyle2(
                  icon: GestureDetector(
                    child: Icon(nightMode ? Icons.light_mode : Icons.dark_mode,
                        size: 20),
                    onTap: () async {
                      nightMode = !nightMode;
                      //SharedPreferences prefs =
                      //    await SharedPreferences.getInstance();
                      //prefs.setBool('nightMode', nightMode);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // A method to show a confirmation dialog before deleting the entry
  Future<void> _showDeleteDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.brown[50],
        title: const Text('Are you sure?'),
        content: const Text('This will delete your diary entry permanently.'),
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
              'Delete',
              style: TextStyle(color: Colors.brown),
            ),
          ),
        ],
      ),
    );
    if (result == true) {
      await _deleteEntry();
    }
  }

  Future<void> _deleteEntry() async {
    removeDiaryEntryByDate(did[pageIndex]);
    Get.back();
    Get.back();
    Get.snackbar("", "Deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }
}
