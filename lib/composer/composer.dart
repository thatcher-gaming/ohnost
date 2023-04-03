import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ohnost/api.dart';
import 'package:ohnost/blocks.dart';
import 'package:ohnost/secrets.dart';
import 'package:ohnost/util.dart';

import '../model.dart';
import 'discard_dialog.dart';

class PostComposer extends StatefulWidget {
  static void showComposeDialog(BuildContext context,
      [Post? sharedPost, bool? comment]) {
    var commentCanon = comment ?? false;
    showMaterialModalBottomSheet(
      context: context,
      animationCurve: Curves.easeInOutCubicEmphasized,
      duration: const Duration(milliseconds: 400),
      useRootNavigator: true,
      bounce: true,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: !commentCanon
            ? PostComposer(
                sharedPost: sharedPost,
              )
            : PostComposer.comment(sharedPost),
      ),
    );
  }

  final Post? sharedPost;
  bool isaComment = false;

  PostComposer({super.key, this.sharedPost});
  PostComposer.comment(this.sharedPost, {super.key}) {
    isaComment = true;
  }

  @override
  State<PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends State<PostComposer> {
  late String postHeadline = "";
  late String postBody = "";
  late bool uploading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> postPost() async {
    setState(() {
      uploading = true;
    });
    if (widget.isaComment) return postComment();
    PostPostRequest postPost = PostPostRequest(
        adultContent: false,
        blocks: [
          if (postBody.isNotEmpty)
            Block(type: "markdown", markdown: MarkdownBlock(content: postBody))
        ],
        headline: postHeadline.isNotEmpty ? postHeadline : "",
        shareOfPostId:
            widget.sharedPost != null ? widget.sharedPost!.postId : null);
    await postPost.send();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> postComment() async {
    var _ = await authenticatedPost(
      Uri.parse("$apiBase/comments"),
      body: jsonEncode({"postId": widget.sharedPost!.postId, "body": postBody}),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  /// Pop up a thing asking if the user wants to close the composer
  Future<bool> tryCloseComposer() async {
    if (postHeadline.isEmpty && postBody.isEmpty) {
      return true;
    }
    bool shouldClose = false;
    await showDialog(
      context: context,
      builder: (context) => DiscardAlert(
        (outcome) => shouldClose = outcome,
        comment: widget.isaComment,
      ),
    );
    return shouldClose;
  }

  @override
  Widget build(BuildContext context) {
    var headlineInput = Opacity(
      opacity: postHeadline.isEmpty ? 0.75 : 1,
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Headline",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            postHeadline = value;
          });
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );

    var postBodyInput = Opacity(
        opacity: postBody.isEmpty ? 0.5 : 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200),
          child: TextField(
            decoration: InputDecoration(
              hintText: widget.isaComment
                  ? "your time here is limited. get mad at a stranger"
                  : "write something wonderful",
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                postBody = value;
              });
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ));

    var postBodyPreview = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preview",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Card(
          elevation: 12,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          color: Theme.of(context).colorScheme.surface,
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: BlocksView([
                  Block(
                      type: "markdown",
                      markdown: MarkdownBlock(content: postBody))
                ])),
          ),
        ),
      ],
    );

    bool canBeSent = postBody.isNotEmpty ||
        postHeadline.isNotEmpty ||
        (widget.sharedPost != null && !widget.isaComment);

    return WillPopScope(
      onWillPop: tryCloseComposer,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        elevation: 4,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 550,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              18,
              36,
              18,
              MediaQuery.of(context).viewInsets.bottom + 36,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.sharedPost != null && !widget.isaComment)
                  ShareIndicator(widget.sharedPost!),
                Wrap(
                  spacing: 12,
                  children: [
                    IconButton(
                        onPressed: () async {
                          bool shouldClose = await tryCloseComposer();
                          if (shouldClose && mounted) {
                            Navigator.of(context).pop();
                          }
                          return;
                        },
                        icon: const Icon(Icons.close)),
                    if (!widget.isaComment)
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit_note)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: widget.isaComment
                                ? Text("Comment",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium)
                                : headlineInput,
                          ),
                          Opacity(
                            opacity: canBeSent ? 1 : 0.25,
                            child: FloatingActionButton.large(
                              onPressed: canBeSent ? () => postPost() : null,
                              elevation: 0,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                              child: uploading
                                  ? CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    )
                                  : const Icon(Icons.arrow_upward),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      postBodyInput,
                      const SizedBox(
                        height: 8,
                      ),
                      if (postBody.isNotEmpty) postBodyPreview
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

class ShareIndicator extends StatelessWidget {
  final Post sharedPost;

  const ShareIndicator(this.sharedPost, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              Icon(
                Icons.cached,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              Text(
                "Sharing @${sharedPost.postingProject.handle}'s post",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
            ],
          )),
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
    final Uri endpoint =
        Uri.parse("$apiBase/project/${AppSecrets.currentProjectHandle}/posts");
    Response res = await authenticatedPost(endpoint, body: jsonString);
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
