import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/posts/user_info.dart';
import 'package:routemaster/routemaster.dart';

class TagList extends StatelessWidget {
  const TagList(this.tags, {super.key});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tags", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(
            height: 8,
          ),
          for (var tag in tags) TagEntry(tag),
        ],
      ),
    );
  }
}

class TagEntry extends StatelessWidget {
  TagEntry(String tag, {super.key}) {
    this.tag = tag.length <= 24 ? tag : "${tag.substring(0, 24)}…";
  }

  late final String tag;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),
        foregroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.onSurface));

    return Card(
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: () {
          Routemaster.of(context).push("/tag/$tag");
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(tag, overflow: TextOverflow.ellipsis),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_add_outlined),
                style: buttonStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
