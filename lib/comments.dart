import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ohnost/composer/composer.dart';
import 'package:ohnost/posts/main.dart';
import 'package:ohnost/posts/user_info.dart';
import 'package:ohnost/secrets.dart';
import 'package:routemaster/routemaster.dart';

import 'model.dart';

class CommentStream extends StatelessWidget {
  final Map<String, List<CommentOuter>> comments;
  const CommentStream(this.comments, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> commentWidgets = [];
    comments.forEach(
      (key, value) {
        value.forEach((element) {
          Widget widget = CommentView(
            element,
            depth: 0,
          );
          commentWidgets.add(widget);
        });
      },
    );
    return Column(
      children: [...commentWidgets],
    );
  }
}

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CommentView extends StatelessWidget {
  final CommentOuter comment;
  final int depth;
  const CommentView(this.comment, {required this.depth, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shadowColor: Colors.transparent,
          color: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: depth.toDouble() + 2,
          margin: EdgeInsets.fromLTRB(12 + (depth * 24), 8, 12, 8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoPart(comment.poster),
                MarkdownBody(
                    data: comment.comment.body,
                    styleSheet: MarkdownStyleSheet(textScaleFactor: 1.2)),
              ],
            ),
          ),
        ),
        for (var childComment in comment.comment.children)
          CommentView(childComment, depth: depth + 1)
      ],
    );
  }
}

class CommentButtonThing extends StatelessWidget {
  final Post post;

  const CommentButtonThing(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    var self = AppSecrets.getSelf();

    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      elevation: 2,
      child: SizedBox(
        width: double.infinity,
        child: FutureBuilder(
            future: self,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CommentButtonThingInner(snapshot.data!, post);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class CommentButtonThingInner extends StatelessWidget {
  const CommentButtonThingInner(this.project, this.post, {super.key});

  final PostingProject project;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Routemaster.of(context).push("/comment/${post.postId}");
      },
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Wrap(
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ProfilePicture(
              project.avatarPreviewURL,
              width: 28,
              height: 28,
              borderRadius: BorderRadius.circular(6),
            ),
            Text(
              "now's your chance to say something…",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.outline),
            )
          ],
        ),
      ),
    );
  }
}
