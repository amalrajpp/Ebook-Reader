import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_pass.dart';
import 'controller.dart';
import 'datestyle.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool lockEnabled = false;
  bool dateHide = false;
  bool notification = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    getLockPreference();
  }

  void getLockPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lockEnabled = prefs.getBool('lockEnabled') ?? false;
      dateHide = prefs.getBool('dateHide') ?? false;
      notification = prefs.getBool('notification') ?? false;
    });
  }

  void setLockPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lockEnabled = value;
      prefs.setBool('lockEnabled', value);
      AppLock.of(context)!.setEnabled(value);
    });
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(1, 'plain title',
        'plain body', RepeatInterval.daily, notificationDetails,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFE7DBC9),
        title: const Text('Settings'),
      ),
      body: SettingsList(
        lightTheme: const SettingsThemeData(
            settingsListBackground: Color(0XFFE7DBC9),
            titleTextColor: Colors.brown),
        sections: [
          SettingsSection(
            title: const Text('Customize'),
            tiles: [
              SettingsTile(
                title: const Text('Date format'),
                leading: const Icon(Icons.date_range),
                onPressed: (BuildContext context) {
                  Get.to(const DateFormatScreen());
                },
              ),
              SettingsTile.switchTile(
                  leading: const Icon(Icons.visibility_off_outlined),
                  title: const Text('Hide Date'),
                  initialValue: dateHide,
                  onToggle: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      dateHide = value;
                      prefs.setBool('dateHide', value);
                    });
                  }),
              SettingsTile.switchTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notification'),
                  initialValue: notification,
                  onToggle: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      notification = value;
                      prefs.setBool('notification', value);
                      showNotification();
                    });
                  }),
            ],
          ),
          SettingsSection(
            title: const Text('Security'),
            tiles: [
              SettingsTile.switchTile(
                leading: const Icon(Icons.lock),
                title: const Text('Lock Screen'),
                initialValue: lockEnabled,
                onToggle: (value) async {
                  if (value == false) {
                    setState(() {
                      setLockPreference(value);
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Card(
                              color: const Color(0XFFEEE3C0),
                              clipBehavior: Clip.none,
                              elevation: 6.0,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(28.0))),
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 30),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Create new password",
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 22,
                                                    color: Color(0xFF4E352A)),
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(height: 30),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscureText,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        maxLength: 4,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(_obscureText
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a password';
                                          }
                                          if (value.length != 4) {
                                            return 'Password must be 4 digits';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                      TextFormField(
                                        controller: _confirmController,
                                        obscureText: _obscureText,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        maxLength: 4,
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(_obscureText
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 32.0),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // Save the password to shared preferences
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setString('password',
                                                _passwordController.text);
                                            final Controller c =
                                                Get.find<Controller>();
                                            c.password =
                                                _passwordController.text;
                                            // Navigate to the next screen or show a success message
                                            Get.back();
                                            Get.snackbar("",
                                                "Password created successfully",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                duration:
                                                    const Duration(seconds: 2));
                                            setLockPreference(value);
                                          }
                                        },
                                        child: const Text(
                                          'Create Password',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
              SettingsTile(
                title: const Text('Change Password'),
                leading: const Icon(Icons.vpn_key),
                onPressed: (BuildContext context) {
                  Get.to(const ChangePasswordScreen());
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('About'),
            tiles: [
              SettingsTile(
                title: const Text('Version'),
                leading: const Icon(Icons.info),
              ),
              SettingsTile(
                title: const Text('Feedback'),
                leading: const Icon(Icons.feedback),
                onPressed: (BuildContext context) {
                  // You can use any widget to show the feedback form here
                },
              ),
              SettingsTile(
                title: const Text('Rate Us'),
                leading: const Icon(Icons.star),
                onPressed: (BuildContext context) async {
                  final InAppReview inAppReview = InAppReview.instance;
                  bool isAvailable = await inAppReview.isAvailable();
                  if (isAvailable) {
                    if (isAvailable) {
                      inAppReview.requestReview();
                      inAppReview.openStoreListing(
                          appStoreId: 'com.android.chrome');
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
