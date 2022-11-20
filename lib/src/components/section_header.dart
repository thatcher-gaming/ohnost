import 'package:flutter/widgets.dart';
import 'package:ohnost/src/app.dart';

TextStyle titleStyle = const TextStyle(fontSize: 24);
TextStyle subtitleStyle = const TextStyle(
    fontSize: 13, color: Colours.stone400, fontStyle: FontStyle.italic);

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<IconData>? iconz;

  const SectionHeader(this.title, {this.subtitle, this.iconz, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.stone300,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colours.stone400, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Application.theme.textTheme.displaySmall!),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: subtitleStyle,
                      ),
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
                    )
                ]),
              )
          ],
        ),
      ),
    );
  }
}
