import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ohnost/blocks.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/posts/main.dart';
import 'package:ohnost/posts/user_info.dart';

class ShareTree extends StatelessWidget {
  final Post post;
  const ShareTree(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          for (var sharedPost in post.shareTree)
            if (sharedPost.blocks.isNotEmpty || sharedPost.headline.isNotEmpty)
              SharedPost(sharedPost)
        ],
      ),
    );
  }
}

class SharedPost extends StatelessWidget {
  final Post sharedPost;
  const SharedPost(this.sharedPost, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shadowColor: Colors.transparent,
        elevation: 7,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Column(children: [
            UserInfoPart(sharedPost.postingProject),
            BlocksView.frompost(sharedPost, truncate: true,)
          ]),
        ),
      ),
    );
  }
}
