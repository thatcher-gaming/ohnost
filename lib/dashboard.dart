import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ohnost/main.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/posts/main.dart';
import 'package:ohnost/poststream.dart';
import 'package:routemaster/routemaster.dart';
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
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      floatingActionButton: OpenContainer(
        closedBuilder: (BuildContext context, void Function() action) {
          return FloatingActionButton(
              heroTag: "add_post",
              onPressed: () => action(),
              child: const Icon(Icons.add));
        },
        closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(16),
        )),
        closedColor: Theme.of(context).colorScheme.primaryContainer,
        closedElevation: 6,
        openBuilder: (context, action) {
          return PostComposer();
        },
        openColor: Theme.of(context).colorScheme.surface,
        routeSettings: const RouteSettings(name: "/composer"),
        useRootNavigator: true,
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 450),
      ),
      body: PostStream(
          postGetter: (cursor, limit, [timestamp]) {
            return PostList.fromHomeFeed(
              cursor: cursor,
              timestamp: timestamp,
            ).postFuture;
          },
          incrementCursorBy: 20,
          titleWidget: const Text("Dashboard")),
    );
  }
}
