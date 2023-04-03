import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ohnost/main.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/posts/main.dart';
import 'package:ohnost/poststream.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'composer/composer.dart';

class OhnostDashboard extends StatefulWidget {
  const OhnostDashboard({super.key});

  @override
  State<OhnostDashboard> createState() => _OhnostDashboardState();
}

class _OhnostDashboardState extends State<OhnostDashboard>
    with AutomaticKeepAliveClientMixin<OhnostDashboard> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
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
