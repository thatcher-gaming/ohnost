import 'package:flutter/widgets.dart';
import 'package:ohnost/src/cohost/posts.dart';
import 'package:ohnost/src/components/layouts.dart';
import 'package:ohnost/src/components/nav/navigation.dart';
import 'package:ohnost/src/components/post_stream.dart';
import 'package:ohnost/src/components/section_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    num cursor = 0;
    var posts = PostQueries.getHomeFeed(cursor);

    return Layout(
      header: const SectionHeader("notifications", iconz: [
        PhosphorIcons.arrowsClockwise,
        PhosphorIcons.x,
        PhosphorIcons.dotsThree
      ]),
      content: Column(
        children: [Text("hi!")],
      ),
      nav: const NavigationBar([
        NavigationItem(
          "Dashboard",
          PhosphorIcons.rows,
          "/",
          selected: false,
        ),
        NavigationItem(
          "Notifications",
          PhosphorIcons.lightning,
          "/notifications",
          selected: true,
        ),
        NavigationItem(
          "Find",
          PhosphorIcons.binoculars,
          "/",
          selected: false,
        ),
        NavigationItem(
          "You",
          PhosphorIcons.person,
          "",
          selected: false,
        ),
      ]),
    );
  }
}
