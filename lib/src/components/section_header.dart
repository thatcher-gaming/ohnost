import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle titleStyle = const TextStyle(fontSize: 24);
TextStyle subtitleStyle = GoogleFonts.robotoSerif(
    fontStyle: FontStyle.italic,
    textStyle: const TextStyle(
        fontSize: 13, color: Color.fromARGB(255, 150, 150, 150)));

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> iconz;

  const SectionHeader(this.title, this.subtitle, this.iconz, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: subtitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Wrap(spacing: 12, children: iconz),
        )
      ],
    );
  }
}
