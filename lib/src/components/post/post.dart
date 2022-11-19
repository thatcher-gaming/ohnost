import 'dart:ui';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ohnost/src/app.dart';
import 'package:ohnost/src/cohost/model.dart';
import 'package:ohnost/src/components/post/blocks.dart';

class Headline extends StatelessWidget {
  final String headline;

  const Headline(this.headline, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: SelectableText(headline,
            style: Application.theme.textTheme.headlineMedium));
  }
}

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
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UserDetails(
            post.postingProject,
            timeDate: post.publishedAt,
          ),
          if (post.headline != "") Headline(post.headline),
          BlocksList(blocks: post.blocks)
        ]),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  final PostingProject project;
  final String timeDate;

  const UserDetails(this.project, {required this.timeDate, super.key});

  @override
  Widget build(BuildContext context) {
    if (project.displayName is String) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => {
                Application.router.navigateTo(
                    context, "/user/${project.handle}",
                    transition: TransitionType.material)
              },
              child: Wrap(
                spacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image(
                      image: NetworkImage(project.avatarPreviewURL),
                      width: 18,
                      height: 18,
                      excludeFromSemantics: true,
                    ),
                  ),
                  Text(
                    project.displayName!,
                    style: style,
                  ),
                  Opacity(
                      opacity: 0.5,
                      child: Text(
                        "@${project.handle}",
                        style: const TextStyle(
                          fontFamily: 'Roboto Serif',
                        ),
                      ))
                ],
              ),
            ),
          ));
    } else {
      return Row(
        children: [
          Text(
            "@${project.handle}",
          )
        ],
      );
    }
  }

  final style = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
  );
}
