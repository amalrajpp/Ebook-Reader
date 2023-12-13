import 'package:ebook/fetch_diary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryUpdateScreen extends StatefulWidget {
  final String text;
  final DateTime entrydate;
  final String did;
  const DiaryUpdateScreen(
      {Key? key,
      required this.text,
      required this.entrydate,
      required this.did})
      : super(key: key);

  @override
  DiaryUpdateScreenState createState() => DiaryUpdateScreenState();
}

class DiaryUpdateScreenState extends State<DiaryUpdateScreen> {
  // A text editing controller for the text field
  final TextEditingController _textController = TextEditingController();

  // A variable to store the selected date
  late DateTime _selectedDate;

  String? did;

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

  // A method to show a confirmation dialog before deleting the entry
  Future<void> _showDeleteDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This will delete your diary entry permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (result == true) {
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.entrydate;
    _textController.text = widget.text;
    did = widget.did;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
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
    updateDiaryEntryByDate(
        did!, {'content': entry, 'timestamp': _selectedDate});
    Get.back();
  }
}
