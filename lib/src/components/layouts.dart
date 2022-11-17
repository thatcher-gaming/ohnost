import 'package:flutter/widgets.dart';

class Layout extends StatelessWidget {
  final Widget nav;
  final Widget content;
  final Widget header;

  const Layout(this.header, this.content, this.nav, {super.key});

  @override
  Widget build(BuildContext context) {
    final scrollControl = ScrollController();
    return Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(
            children: [
              // provide ample padding for the status bar on android
              Container(
                  height: MediaQuery.of(context).viewPadding.top,
                  color: const Color.fromARGB(255, 75, 75, 75)),
              header,
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  children: [content],
                ),
              ),
            ],
          );
        }));
  }
}
