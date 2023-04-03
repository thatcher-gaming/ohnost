import 'package:flutter/material.dart';
import 'package:ohnost/posts/tags.dart';
import 'package:ohnost/posts/user_info.dart';
import 'package:ohnost/shares.dart';
import '../blocks.dart';
import '../model.dart';
import 'actions.dart';
import 'date.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool truncate;

  const PostView({
    required this.post,
    this.truncate = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: post.postId,
      child: Card(
          shadowColor: Colors.transparent,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // the bit saying who the user is
                UserInfoPart(post.postingProject, date: post.publishedAt,),
                // show previous shares if they exist
                if (post.shareTree.isNotEmpty) ShareTree(post),
                // the post content itself
                BlocksView.frompost(post, truncate: truncate),
                // the tags if they exist
                if (post.tags.isNotEmpty) TagList(post.tags),
                // fun buttons
                PostViewActions(post)
              ],
            ),
          )),
    );
  }
}
