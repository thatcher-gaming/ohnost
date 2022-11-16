import 'package:flutter/widgets.dart';

class Layout extends StatelessWidget {
  final Widget nav;
  final Widget content;
  final Widget header;

  const Layout(this.header, this.content, this.nav, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Column(
                children: [
                  header,
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                            minWidth: viewportConstraints.maxWidth),
                        child: content,
                      ),
                    ),
                  ),
                ],
              );
            })));
  }
}
