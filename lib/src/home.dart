import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ohnost/src/cohost/posts.dart';
import 'package:ohnost/src/components/layouts.dart';
import 'package:ohnost/src/components/nav/navigation.dart';
import 'package:ohnost/src/components/post_stream.dart';
import 'package:ohnost/src/components/section_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    num cursor = 0;
    var posts = PostQueries.getHomeFeed(cursor);

    return Layout(
      header: SectionHeader(AppLocalizations.of(context)!.homePageTitle,
          iconz: const [
            PhosphorIcons.arrowsClockwise,
            PhosphorIcons.dotsThree,
          ]),
      content: Column(
        children: [
          PostStream(posts: posts),
          GestureDetector(
            onTap: () => {},
            child: Text("please.. more posts"),
          )
        ],
      ),
      nav: const NavigationBar([
        NavigationItem(
          "Dashboard",
          PhosphorIcons.rows,
          selected: true,
        ),
        NavigationItem(
          "Notifications",
          PhosphorIcons.lightning,
          selected: false,
        ),
        NavigationItem(
          "Find",
          PhosphorIcons.binoculars,
          selected: false,
        ),
        NavigationItem(
          "You",
          PhosphorIcons.person,
          selected: false,
        ),
      ]),
    );
  }
}
