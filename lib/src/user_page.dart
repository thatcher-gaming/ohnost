import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:ohnost/src/components/layouts.dart';
import 'package:ohnost/src/components/section_header.dart';

class UserPage extends StatelessWidget {
  final String handle;

  const UserPage(this.handle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(header: SectionHeader("@$handle"), content: Text("hi"));
  }
}
