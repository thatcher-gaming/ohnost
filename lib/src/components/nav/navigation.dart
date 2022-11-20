import 'package:flutter/widgets.dart';
import 'package:ohnost/src/app.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar(this.items, {super.key});

  final List<NavigationItem> items;

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.stone300,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: Colours.stone400))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  for (var item in widget.items)
                    GestureDetector(
                      onTap: () => {},
                      child: item,
                    )
                ],
              )),
        ),
      ),
    );
  }
}

class NavigationItem extends StatefulWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const NavigationItem(this.name, this.icon,
      {required this.selected, super.key});

  @override
  State<NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000),
      child: Container(
        color: widget.selected ? Colours.stone800 : Colours.stone300,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.selected ? Colours.stone050 : Colours.stone900,
              size: 18,
            ),
            if (widget.selected)
              Text(widget.name,
                  style: Application.theme.textTheme.labelMedium!
                      .copyWith(color: Colours.stone050))
          ],
        ),
      ),
    );
  }
}
