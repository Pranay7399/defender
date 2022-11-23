import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class InstalledAppsCheck extends StatefulWidget {
  const InstalledAppsCheck({super.key});

  @override
  State<InstalledAppsCheck> createState() => _InstalledAppsCheckState();
}

class _InstalledAppsCheckState extends State<InstalledAppsCheck> {
  bool isFetched = false;
  List installedApps = [];

  @override
  void initState() {
    super.initState();
    _fetchInstalledApps();
  }

  Future<void> _fetchInstalledApps() async {
    List<Application> _apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeAppIcons: true,
        includeSystemApps: true);

    setState(() {
      isFetched = true;
      installedApps = _apps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installed Apps'),
      ),
      body: isFetched
          ? ListView.builder(
              itemCount: installedApps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.memory(
                      installedApps[index] is ApplicationWithIcon
                          ? installedApps[index].icon
                          : null),
                  title: Text(installedApps[index].appName),
                  subtitle: Text(installedApps[index].packageName),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
