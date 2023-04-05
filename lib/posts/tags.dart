import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class TagList extends StatelessWidget {
  final List<String> tags;
  const TagList(this.tags, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Wrap(
        spacing: 12,
        children: [
          ...tags.map((e) => GestureDetector(
                onTap: () => Routemaster.of(context).push("/tag/$e"),
                child: Text("#$e"),
              ))
        ],
      ),
    );
  }
}
