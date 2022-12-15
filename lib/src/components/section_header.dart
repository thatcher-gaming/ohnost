import 'package:flutter/widgets.dart';
import 'package:ohnost/src/app.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

TextStyle titleStyle = const TextStyle(fontSize: 24, color: Colours.purple900);
TextStyle subtitleStyle = const TextStyle(
    fontSize: 13, color: Colours.purple700, fontStyle: FontStyle.italic);

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<IconData>? iconz;

  final bool backButtonVisible;

  const SectionHeader(this.title,
      {this.subtitle, this.iconz, this.backButtonVisible = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.purple200,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colours.purple900.withAlpha(50), width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: Wrap(
                spacing: 12,
                children: [
                  if (backButtonVisible)
                    GestureDetector(
                      onTap: () => Routemaster.of(context).pop(),
                      child: const Icon(
                        PhosphorIcons.arrowLeft,
                        size: 20,
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Application.theme.textTheme.displaySmall),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle!,
                            style: subtitleStyle,
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
            if (iconz != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(spacing: 12, children: [
                  for (var icon in iconz!)
                    Icon(
                      icon,
                      size: 20,
                      color: Colours.stone900,
                    )
                ]),
              )
          ],
        ),
      ),
    );
  }
}
