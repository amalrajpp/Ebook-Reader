import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'upload_diary.dart';
import 'package:intl/intl.dart';

class DiaryEntryScreen extends StatefulWidget {
  const DiaryEntryScreen({Key? key}) : super(key: key);

  @override
  DiaryEntryScreenState createState() => DiaryEntryScreenState();
}

class DiaryEntryScreenState extends State<DiaryEntryScreen> {
  // A text editing controller for the text field
  final TextEditingController _textController = TextEditingController();

  // A variable to store the selected date
  DateTime _selectedDate = DateTime.now();

  // A variable to store the selected image

  // A method to pick an image from the gallery or camera

  // A method to show a date picker dialog
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0XFFEEE3CB),
              onPrimary: Color(0xFF4E352A),
              onSurface: Colors.brown,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.brown, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;
    setState(() {
      _selectedDate = date;
    });
  }

  // A method to delete the diary entry from a database or a file
  Future<void> _deleteEntry() async {
    // You can use packages like sqflite, hive, firebase, etc.
    print('Deleting entry...');
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
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        //color: Color(0XFFEBE4D1),
        //color: Color(0XFFF8F0E5),
        //color: Color(0XFFFFF6DC),
        //color: Color(0XFFF2EAD3),
        color: const Color(0XFFEEE3CB),
        clipBehavior: Clip.none,
        elevation: 6.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0))),
            title: TextButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today, color: Color(0xFF4E352A)),
              label: Text(DateFormat.yMMMd().format(_selectedDate),
                  style: const TextStyle(color: Color(0xFF4E352A))),
            ),
            actions: [
              IconButton(
                onPressed: _saveText,
                icon: const Icon(
                  Icons.save,
                  color: Color(0xFF4E352A),
                ),
              ),
              IconButton(
                onPressed: _showDeleteDialog,
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xFF4E352A),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A text field for the diary entry
                  TextField(
                    controller: _textController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Write your thoughts here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // A row of buttons for picking a date
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // A function to save the text to firebase
  Future<void> _saveText() async {
    String entry = _textController.text;
    addDiaryEntry(entry, _selectedDate);
    Get.back();
    Get.snackbar("", "Created successfully",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }
}
