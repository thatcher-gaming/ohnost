import 'package:flutter/widgets.dart';

class Layout extends StatelessWidget {
  final Widget nav;
  final Widget frame;

  const Layout(this.frame, this.nav, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // status bar background
          Container(
            height: MediaQuery.of(context).viewPadding.top,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          nav,
          frame,
        ],
      ),
    );
  }
}
