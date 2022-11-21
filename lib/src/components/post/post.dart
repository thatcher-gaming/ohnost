import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ohnost/src/app.dart';
import 'package:ohnost/src/cohost/model.dart';
import 'package:ohnost/src/components/post/blocks.dart';
import 'package:ohnost/src/components/post/repost.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomBit extends StatefulWidget {
  final bool liked;

  final Post post;

  final num commentCount;
  const BottomBit(
      {required this.liked,
      required this.commentCount,
      required this.post,
      super.key});

  @override
  State<BottomBit> createState() => _BottomBitState();
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
          BlocksList(
            blocks: post.blocks,
            headline: post.headline,
          ),
          BottomBit(
            liked: post.isLiked,
            commentCount: post.numComments,
            post: post,
          )
        ]),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final String uri;

  const ProfilePicture(this.uri, {super.key});

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
            padding: const EdgeInsets.only(bottom: 8),
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

class _BottomBitState extends State<BottomBit> {
  @override
  Widget build(BuildContext context) {
    bool likedState = widget.post.isLiked;

    Future toggleInnerLike() async {
      await widget.post.toggleLikedStatus();

      // set it to the canonical state when all is said and done
      setState(() {
        likedState = widget.post.isLiked;
      });

      // i have no idea how effective this approach is considering
      // the internal Post object can still get out of sync from the
      // server.
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.commentCount} Comments",
            style: Application.theme.textTheme.labelMedium!
                .copyWith(color: Colours.stone700),
          ),
          Wrap(spacing: 12, children: [
            GestureDetector(
              child: const Icon(
                PhosphorIcons.arrowsClockwiseBold,
                size: 20,
              ),
            ),
            GestureDetector(
              onTap: (() async {
                // set the state /immediately/ so the app feels faster than
                // it actually is.
                setState(() {
                  likedState = !likedState;
                });
                toggleInnerLike();
              }),
              child: Icon(
                likedState ? PhosphorIcons.heartFill : PhosphorIcons.heartBold,
                color: likedState ? Colours.purple700 : Colours.stone900,
                size: 20,
              ),
            ),
          ])
        ],
      ),
    );
  }
}
