import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ohnost/comments.dart';
import 'package:ohnost/posts.dart';
import 'package:routemaster/routemaster.dart';

import 'model.dart';

class JustOnePost extends StatelessWidget {
  late final Post? post;
  late final Future<Post>? post_future;
  late final Future<Map<String, List<CommentOuter>>> comments_future;
  late int postID;
  late String handle;

  JustOnePost(this.post, {super.key}) {
    handle = post!.postingProject.handle;
    postID = post!.postId;
  }

  JustOnePost.fromID(this.postID, this.handle, {super.key}) {
    post_future = Post.getPostFromId(postID, handle);
    comments_future = Comments.getCommentsFromId(postID, handle);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (post_future != null) {
      body = FutureBuilder(
        future: post_future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PostView(post: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    } else {
      body = PostView(post: post!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("@$handle's post"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          body,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            child: Text(
              "Comments",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          FutureBuilder(
            future: comments_future,
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
      ),
    );
  }
}
