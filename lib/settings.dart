import 'package:flutter/material.dart';
import 'package:ohnost/db.dart';
import 'package:ohnost/secrets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Future<Setting> cookie = Setting.get("cookie");

    return FutureBuilder(
      future: cookie,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Settings"),
            ),
            body: Column(
              children: [
                TextField(
                  
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
