import 'package:flutter/material.dart';
import 'package:ohnost/comments.dart';
import 'package:ohnost/posts/main.dart';

import 'model.dart';

class JustOnePost extends StatelessWidget {
  late final Post? post;
  Future<Post>? postFuture;
  late final Future<Map<String, List<CommentOuter>>> commentsFuture;
  late final int postID;
  late final String handle;

  JustOnePost(this.post, {super.key}) {
    handle = post!.postingProject.handle;
    postID = post!.postId;
    commentsFuture = Comments.getCommentsFromId(postID, handle);
  }

  JustOnePost.fromJSON(Map<String, dynamic> json, {super.key}) {
    post = Post.fromJson(json);
    handle = post!.postingProject.handle;
    postID = post!.postId;
    commentsFuture = Comments.getCommentsFromId(postID, handle);
  }

  JustOnePost.fromID(this.postID, this.handle, {super.key}) {
    postFuture = Post.getPostFromId(postID, handle);
    commentsFuture = Comments.getCommentsFromId(postID, handle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("@$handle's post"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          postFuture != null
              ? FutureBuilder(
                  future: postFuture,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? _InnerBit(snapshot.data!, commentsFuture)
                        : const Center(child: CircularProgressIndicator());
                  },
                )
              : _InnerBit(post!, commentsFuture),
        ],
      ),
    );
  }
}

class _InnerBit extends StatelessWidget {
  const _InnerBit(this.post, this.commentsFuture);

  final Post post;
  final Future<Map<String, List<CommentOuter>>> commentsFuture;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostView(post: post, usePadding: false),
        CommentButtonThing(post),
        FutureBuilder(
          future: commentsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CommentStream(snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }
}
