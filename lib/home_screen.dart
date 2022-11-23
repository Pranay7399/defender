import 'package:defender/installed_apps_check.dart';
import 'package:defender/messages_screen.dart';
import 'package:defender/sailor.dart';
import 'package:defender/contacts_screen.dart';
import 'package:defender/splash_screen.dart';
import 'package:defender/url_validation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:safe_device/safe_device.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Location location = Location();

  bool isJailBroken = false;
  bool canMockLocation = false;
  bool isRealDevice = true;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  bool isDevelopmentModeEnable = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await location.requestPermission();
    if (!mounted) return;
    try {
      isJailBroken = await SafeDevice.isJailBroken;
      canMockLocation = await SafeDevice.canMockLocation;
      isRealDevice = await SafeDevice.isRealDevice;
      isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      isSafeDevice = await SafeDevice.isSafeDevice;
      isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    } catch (error) {
      print(error);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Defender'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Sailor.replaceStackWith(const SplashScreen());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: isJailBroken
                        ? const Icon(
                            Icons.error,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                    title: Text(isJailBroken
                        ? 'Device is Rroted'
                        : 'Device not rooted'),
                  ),
                  ListTile(
                    leading: canMockLocation
                        ? const Icon(
                            Icons.error,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                    title: Text(canMockLocation
                        ? 'Device can Mock Location'
                        : 'Device cannot mock location'),
                  ),
                  ListTile(
                    leading: !isRealDevice
                        ? const Icon(
                            Icons.error,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                    title: Text(
                        isRealDevice ? 'Real Device' : 'Not a real device'),
                  ),
                  ListTile(
                    leading: isOnExternalStorage
                        ? const Icon(
                            Icons.error,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                    title: Text(isOnExternalStorage
                        ? 'Application is installed on external storage'
                        : 'Application is installed on internal storage'),
                  ),
                  ListTile(
                    leading: !isSafeDevice
                        ? const Icon(
                            Icons.error,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                    title: Text(isSafeDevice
                        ? 'Device is Safe '
                        : 'Device is not safe'),
                  ),
                  ListTile(
                    leading: isDevelopmentModeEnable
                        ? const Icon(
                            Icons.error,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                    title: Text(isDevelopmentModeEnable
                        ? 'Developemt mode is enabled'
                        : 'Development mode is disabled'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    'URL Validation:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Wrap(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Sailor.push(const ContactsScreen());
                        },
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text(
                              'Check \n Contacts',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Sailor.push(const MessagesScreen());
                        },
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text(
                              'Check \n  Messages',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Sailor.push(const UrlValidationScreen());
                        },
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text(
                              'Check \n Spam URL',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Sailor.push(const InstalledAppsCheck());
                        },
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text(
                              'Check \n Installed Apps',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
