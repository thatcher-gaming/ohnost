import 'package:flutter/widgets.dart';
import 'package:ohnost/src/cohost/posts.dart';
import 'package:ohnost/src/components/layouts.dart';
import 'package:ohnost/src/components/post_stream.dart';
import 'package:ohnost/src/components/section_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var posts = PostGetter(handle: "leah").getPosts();
    return Layout(
      SectionHeader("leah's posts",
          AppLocalizations.of(context)!.homePageRefreshTime(5), const [
        Icon(PhosphorIcons.arrowsClockwiseLight),
        Icon(PhosphorIcons.dotsThreeLight),
      ]),
      Column(
        children: [
          PostStream(posts: posts),
        ],
      ),
      // TODO: add navbar
      Container(),
    );
  }
}
