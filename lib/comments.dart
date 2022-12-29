import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ohnost/posts.dart';

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
      children: commentWidgets,
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
