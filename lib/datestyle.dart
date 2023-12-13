import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateFormatScreen extends StatefulWidget {
  const DateFormatScreen({Key? key}) : super(key: key);

  @override
  DateFormatScreenState createState() => DateFormatScreenState();
}

class DateFormatScreenState extends State<DateFormatScreen> {
  // A list of date formats to display
  List<String> formats = [
    'EEEE, MMMM d, y',
    'yyyy-MM-dd',
    'dd/MM/yyyy',
    'MM/dd/yyyy',
    'dd-MMM-yyyy',
    'd/M/yy',
  ];

  // The current selected format
  String? selectedFormat;

  // The current date and time
  DateTime now = DateTime.now();

  // The key for storing the selected format
  String selectedFormatKey = 'dateFormat';

  // The instance of shared preferences
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    // Get the instance of shared preferences
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      // Get the value of the selected format from shared preferences
      String? storedFormat = prefs?.getString(selectedFormatKey);
      // If there is no value, use a default format
      storedFormat ??= 'EEEE, MMMM d, yyyy';
      // Set the selected format to the stored format
      setState(() {
        selectedFormat = storedFormat;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Format Screen'),
        backgroundColor: const Color(0XFFE7DBC9),
      ),
      body: Container(
        color: const Color(0XFFE7DBC9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // A list view to display the list of formats
              Expanded(
                child: ListView.builder(
                  itemCount: formats.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(DateFormat(formats[index]).format(now)),
                      // Highlight the selected format with a color
                      trailing: formats[index] == selectedFormat
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        // Store the selected format to shared preferences
                        prefs?.setString(selectedFormatKey, formats[index]);
                        // Set the selected format to the tapped format
                        setState(() {
                          selectedFormat = formats[index];
                        });
                      },
                    );
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
