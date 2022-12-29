import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ohnost/composer.dart';
import 'package:ohnost/secrets.dart';
import 'package:ohnost/shares.dart';
import 'package:routemaster/routemaster.dart';

import 'api.dart';
import 'blocks.dart';
import 'main.dart';
import 'model.dart';

class PostView extends StatelessWidget {
  final Post post;

  const PostView({
    required this.post,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Colors.transparent,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoPart(post.postingProject),
              if (post.shareTree.isNotEmpty) ShareTree(post),
              BlocksView.frompost(post),
              if (post.tags.isNotEmpty) TagList(post.tags),
              PostViewActions(post)
            ],
          ),
        ));
  }
}

class UserInfoPart extends StatelessWidget {
  final PostingProject user;

  const UserInfoPart(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> children;
    if (user.displayName is String) {
      children = [
        Text(user.displayName!),
        Text(
          "@${user.handle}",
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        )
      ];
    } else {
      children = [
        Text("@${user.handle}"),
      ];
    }
    return Wrap(children: [
      TextButton(
          onPressed: () {
            Routemaster.of(context).push("/profile/${user.handle}");
          },
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              shape: const MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              textStyle: MaterialStatePropertyAll(
                  Theme.of(context).textTheme.titleMedium),
              foregroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.onSurface)),
          child: Wrap(
            spacing: 12,
            children: [
              ProfilePicture(user.avatarPreviewURL),
              Wrap(
                spacing: 8,
                children: children,
              )
            ],
          )),
      const SizedBox(
        width: double.infinity,
      ),
    ]);
  }
}

class ProfilePicture extends StatelessWidget {
  final String uri;

  const ProfilePicture(this.uri, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Semantics(
        hidden: true,
        child: CachedNetworkImage(
          imageUrl: uri,
          cacheManager: cacheManager,
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}

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
          TextButton(
            onPressed: () {
              Routemaster.of(context).push(
                  '/post/${widget.post.postingProject.handle}/${widget.post.postId}');
            },
            style: buttonStyle,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.post.numSharedComments == 0
                      ? "${widget.post.numComments} ${widget.post.numComments == 1 ? "Comment" : "Comments"}"
                      : "${widget.post.numSharedComments + widget.post.numComments} ${widget.post.numComments == 1 ? "Comment" : "Comments"} (${widget.post.numSharedComments} Shared)",
                )),
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
          : const Icon(Icons.favorite_border),
      style: isLiked ? widget.selectedButtonStyle : widget.buttonStyle,
    );
  }
}

class PostPostRequest {
  late int postState;
  late String headline;
  late bool adultContent;
  late List<Block> blocks;
  late List<String> cws;
  late List<String> tags;
  late int? shareOfPostId;

  PostPostRequest({
    this.postState = 1,
    this.headline = "",
    this.adultContent = false,
    this.blocks = const [],
    this.cws = const [],
    this.tags = const [],
    this.shareOfPostId,
  });

  Future<void> send() async {
    String jsonString = jsonEncode(toJson());
    print(jsonString);
    final Uri endpoint =
        Uri.parse("$apiBase/project/${AppSecrets.currentProjectHandle}/posts");
    Response res = await post(endpoint,
        headers: {
          'Cookie': 'connect.sid=${AppSecrets.cookie}',
          'Content-Type': 'application/json'
        },
        body: jsonString);
    print("status code: ${res.statusCode}");
  }

  PostPostRequest.fromJson(Map<String, dynamic> json) {
    postState = json['postState'];
    headline = json['headline'];
    adultContent = json['adultContent'];
    if (json['blocks'] != null) {
      blocks = <Block>[];
      json['blocks'].forEach((v) {
        blocks.add(Block.fromJson(v));
      });
    }
    cws = json['cws'].cast<String>();
    tags = json['tags'].cast<String>();
    shareOfPostId = json['shareOfPostId'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['postState'] = postState;
    data['headline'] = headline;
    data['adultContent'] = adultContent;
    if (blocks != null) {
      data['blocks'] = blocks.map((v) => v.toJson()).toList();
    }
    data['cws'] = cws;
    data['tags'] = tags;
    if (shareOfPostId != null) data['shareOfPostId'] = shareOfPostId;
    return data;
  }
}

class TagList extends StatelessWidget {
  final List<String> tags;
  const TagList(this.tags, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Wrap(
        spacing: 12,
        children: [
          ...tags.map((e) => GestureDetector(
                onTap: () => Routemaster.of(context).push("/tag/$e"),
                child: Text("#$e"),
              ))
        ],
      ),
    );
  }
}
