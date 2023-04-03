import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class DateView extends StatelessWidget {
  final String rawDate;
  late final Jiffy parsedDate;
  late final String formattedDate;
  DateView(this.rawDate, {super.key}) {
    parsedDate = Jiffy.parse(rawDate);
    formattedDate = parsedDate.fromNow();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedDate,
      style: Theme.of(context).textTheme.labelSmall,
      );
  }
}
