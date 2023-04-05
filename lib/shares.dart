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
        elevation: 1,
        shape: const Border(),
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoPart(
                sharedPost.postingProject,
                date: sharedPost.publishedAt,
              ),
              BlocksView.frompost(
                sharedPost,
                truncate: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
