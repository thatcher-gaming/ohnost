import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:ohnost/src/app.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

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
      color: Colours.purple200,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1, color: Colours.purple300.withAlpha(50)))),
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
  final String route;

  const NavigationItem(this.name, this.icon, this.route,
      {required this.selected, super.key});

  @override
  State<NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "${widget.name} Tab",
      child: GestureDetector(
        // TODO: nicer transition, maintain state, etc
        // there should really only be one navbar widget
        // per app instance really
        onTap: () => Routemaster.of(context).push(widget.route),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: Container(
            color: widget.selected ? Colours.purple900 : Colours.purple200,
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
        ),
      ),
    );
  }
}

const NavigationBar defaultNav = NavigationBar([
  NavigationItem(
    "Dashboard",
    PhosphorIcons.rows,
    "/",
    selected: true,
  ),
  NavigationItem(
    "Notifications",
    PhosphorIcons.lightning,
    "/notifications",
    selected: false,
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
]);
