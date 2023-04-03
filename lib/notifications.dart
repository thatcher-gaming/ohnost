import 'package:flutter/material.dart';

class OhnostNotifications extends StatelessWidget {
  const OhnostNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: const Center(
        child: Text('Hello Notifications!'),
      ),
    );
  }
}
