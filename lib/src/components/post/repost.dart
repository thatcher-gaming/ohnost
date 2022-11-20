import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ohnost/src/app.dart';
import 'package:ohnost/src/cohost/model.dart';
import 'package:ohnost/src/components/post/blocks.dart';
import 'package:ohnost/src/components/post/post.dart';

class RepostView extends StatelessWidget {
  final Post repost;

  const RepostView(this.repost, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colours.stone200, width: 1),
            color: Colours.stone100,
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              UserDetails(repost.postingProject, timeDate: repost.publishedAt),
              BlocksList(blocks: repost.blocks),
            ],
          ),
        ),
      ),
    );
  }
}
