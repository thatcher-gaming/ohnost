import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ohnost/main.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/posts.dart';
import 'package:ohnost/poststream.dart';

import 'composer.dart';

class OhnostDashboard extends StatelessWidget {
  const OhnostDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
          onPressed: () => PostComposer.showComposeDialog(context),
          child: const Icon(Icons.add)),
      body: PostStream(
          postGetter: (cursor, limit) {
            return PostList.fromHomeFeed(cursor: cursor).postFuture;
          },
          incrementCursorBy: 20,
          titleWidget: const Text("Dashboard")),
    );
  }
}
