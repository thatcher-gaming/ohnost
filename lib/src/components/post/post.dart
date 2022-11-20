import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ohnost/src/app.dart';
import 'package:ohnost/src/cohost/model.dart';
import 'package:ohnost/src/components/post/blocks.dart';
import 'package:ohnost/src/components/post/repost.dart';

class Headline extends StatelessWidget {
  final String headline;

  const Headline(this.headline, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 8),
        child: SelectableText(headline,
            style: Application.theme.textTheme.headlineLarge));
  }
}

class PostView extends StatelessWidget {
  final Post post;
  const PostView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colours.stone300))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UserDetails(
            post.postingProject,
            timeDate: post.publishedAt,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                for (var post in post.shareTree)
                  if (post.transparentShareOfPostId == null) RepostView(post),
              ],
            ),
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
      return SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => {
                      Application.router.navigateTo(
                          context, "/user/${project.handle}",
                          transition: TransitionType.native)
                    },
                    child: Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ProfilePicture(project.avatarPreviewURL),
                        Text(
                          project.displayName!,
                          style: Application.theme.textTheme.labelMedium,
                        ),
                        Opacity(
                            opacity: 0.5,
                            child: Text("@${project.handle}",
                                style:
                                    Application.theme.textTheme.labelMedium)),
                      ],
                    ),
                  ),
                ),
                Text(Jiffy(DateTime.parse(timeDate)).fromNow(),
                    style: Application.theme.textTheme.labelSmall!
                        .copyWith(fontStyle: FontStyle.italic))
              ],
            )),
      );
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
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(this.uri, {super.key});

  final String uri;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colours.stone200),
          borderRadius: BorderRadius.circular(4)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image(
          image: NetworkImage(uri),
          width: 18,
          height: 18,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
