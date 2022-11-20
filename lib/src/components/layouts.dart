import 'package:flutter/widgets.dart';
import 'package:ohnost/src/app.dart';

class Base extends StatelessWidget {
  final List<Widget> content;

  const Base(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colours.stone050,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(children: [
            // provide ample padding for the status bar on android
            Container(
                height: MediaQuery.of(context).viewPadding.top,
                color: Colours.stone300),
            ...content
          ]);
        }));
  }
}

class Layout extends StatelessWidget {
  final Widget? nav;
  final Widget content;
  final Widget header;

  const Layout(
      {required this.header, required this.content, this.nav, super.key});

  @override
  Widget build(BuildContext context) {
    // final scrollControl = ScrollController();
    return Base(
      [
        header,
        Expanded(
          child: ListView(
            shrinkWrap: true,
            controller: Application.scrollControl,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: [content],
          ),
        ),
        if (nav != null) nav!
      ],
    );
  }
}
