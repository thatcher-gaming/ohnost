import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';

import '../composer/composer.dart';
import '../model.dart';
import '../secrets.dart';

class PostViewActions extends StatefulWidget {
  final Post post;

  const PostViewActions(this.post, {super.key});

  @override
  State<PostViewActions> createState() => _PostViewActionsState();
}

class _PostViewActionsState extends State<PostViewActions> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked;
  }

  Future<void> deletePost() async {
    bool shouldDelete = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text("Delete this Post?"),
                content: const Text(
                    "Are you sure you want to delete this post? This cannot be undone."),
                icon: const Icon(Icons.delete),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            shouldDelete = false;
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            shouldDelete = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text("Delete It"))
                    ],
                  ),
                ]));
    if (shouldDelete) {
      widget.post.deletePost();
    }
  }

  List<Widget> extraOptions(ButtonStyle buttonStyle) {
    return [
      IconButton(
        onPressed: () => deletePost(),
        icon: const Icon(Icons.delete_outline),
        style: buttonStyle,
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.edit_outlined),
        style: buttonStyle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),
        foregroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.onSurface));
    final ButtonStyle selectedButtonStyle = ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
        iconColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.onPrimary));

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommentsButton(
            widget.post,
            buttonStyle: buttonStyle,
          ),
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              if (widget.post.postingProject.handle ==
                  AppSecrets.currentProjectHandle)
                ...extraOptions(buttonStyle),
              Opacity(
                opacity: !widget.post.sharesLocked ? 1 : 0.4,
                child: IconButton(
                  onPressed: !widget.post.sharesLocked
                      ? () {
                          HapticFeedback.lightImpact();
                          PostComposer.showComposeDialog(context, widget.post);
                        }
                      : null,
                  icon: const Icon(Icons.cached),
                  style: buttonStyle,
                ),
              ),
              LikeButton(widget.post, buttonStyle, selectedButtonStyle),
            ],
          ),
        ],
      ),
    );
  }
}

class CommentsButton extends StatelessWidget {
  const CommentsButton(
    this.post, {
    super.key,
    required this.buttonStyle,
  });

  final ButtonStyle buttonStyle;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Routemaster.of(context).push(
            '/profile/${post.postingProject.handle}/${post.postId}',
            queryParameters: {"post": jsonEncode(post.sourceJson)});
      },
      style: buttonStyle,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 20,
                ),
                if (post.numComments + post.numSharedComments != 0)
                  Text(
                    post.numSharedComments == 0
                        ? "${post.numComments}"
                        : "${post.numSharedComments + post.numComments} (${post.numSharedComments} Shared)",
                  ),
              ])),
    );
  }
}

class LikeButton extends StatefulWidget {
  final Post post;
  final ButtonStyle buttonStyle;
  final ButtonStyle selectedButtonStyle;

  const LikeButton(this.post, this.buttonStyle, this.selectedButtonStyle,
      {super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked;
  }

  void toggle() async {
    // swap the value immediately so the app feels faster than it
    // actually is
    setState(() {
      isLiked = !isLiked;
    });
    HapticFeedback.lightImpact();

    bool actualStatus = await widget.post.toggleLikedStatus();
    // set the state to the real value after all is said and done.
    setState(() {
      isLiked = actualStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => toggle(),
      icon: isLiked
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_outline),
      style: isLiked ? widget.selectedButtonStyle : widget.buttonStyle,
    );
  }
}
