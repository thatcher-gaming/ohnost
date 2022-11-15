import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:ohnost/src/cohost/posts.dart';
import 'package:ohnost/src/components/layouts.dart';
import 'package:ohnost/src/components/section_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    PostGetter(handle: "leah").getPosts().then((value) => print(value));
    return Layout(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionHeader(AppLocalizations.of(context)!.homePageTitle,
              AppLocalizations.of(context)!.homePageRefreshTime(5), const [
            Icon(PhosphorIcons.arrowsClockwiseLight),
            Icon(PhosphorIcons.dotsThreeLight),
          ])
        ]),
      ),
      Container(),
    );
  }
}
