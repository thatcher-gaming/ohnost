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
  final bool usePadding;

  const PostView({
    required this.post,
    this.truncate = false,
    this.usePadding = true,
    super.key,
  });

  final insets = const EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: post.postId,
      child: Card(
        shadowColor: Colors.transparent,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        color: Theme.of(context).colorScheme.surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: ClipRect(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // the bit saying who the user is
                Padding(
                    padding: insets,
                    child: EmbiggenedUserInfo(
                      post.postingProject,
                      date: post.publishedAt,
                    )),
                // show previous shares if they exist
                if (post.shareTree.isNotEmpty) ShareTree(post),
                Padding(
                  padding: insets,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // the post content itself
                      BlocksView.frompost(post, truncate: truncate),
                      // the tags if they exist
                      if (post.tags.isNotEmpty) TagList(post.tags),
                      // fun buttons
                      PostViewActions(post)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
