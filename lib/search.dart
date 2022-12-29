import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(
                hintText: "looking for something?",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant),
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ]),
      ),
    );
  }
}
