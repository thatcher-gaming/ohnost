import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ohnost/src/app.dart';
import 'package:ohnost/src/cohost/model.dart';
import 'package:ohnost/src/components/post/blocks.dart';

class PostView extends StatelessWidget {
  final Post post;
  const PostView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black12),
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (post.headline != "") Headline(post.headline),
          BlocksList(blocks: post.blocks)
        ]),
      ),
    );
  }
}

class Headline extends StatelessWidget {
  const Headline(this.headline, {super.key});

  final String headline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(headline, style: Application.theme.textTheme.headlineMedium),
    );
  }
}
