import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ohnost/blocks.dart';
import 'package:ohnost/posts.dart';

import 'model.dart';

class PostComposer extends StatefulWidget {
  static void showComposeDialog(BuildContext context, [Post? sharedPost]) {
    showMaterialModalBottomSheet(
      context: context,
      animationCurve: Curves.easeOutQuart,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: PostComposer(
          sharedPost: sharedPost,
        ),
      ),
    );
  }

  final Post? sharedPost;

  const PostComposer({super.key, this.sharedPost});

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

  Future<bool> closeComposer() async {
    if (postHeadline.isEmpty && postBody.isEmpty) {
      return true;
    }
    bool shouldClose = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Discard this post?"),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          icon: const Icon(Icons.warning),
          content: const Text(
              "You won't be able to get this post back if you discard it."),
          actions: [
            TextButton(
                onPressed: () {
                  shouldClose = true;
                  Navigator.of(context).pop();
                },
                child: const Text("Discard")),
            TextButton(
                onPressed: () {
                  shouldClose = false;
                  Navigator.of(context).pop();
                },
                child: const Text("Keep Writing")),
          ],
        );
      },
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
            decoration: const InputDecoration(
              hintText: "write something wonderful",
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
        widget.sharedPost != null;

    return WillPopScope(
      onWillPop: closeComposer,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        elevation: 4,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 550,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.sharedPost != null)
                  ShareIndicator(widget.sharedPost!),
                Wrap(
                  spacing: 12,
                  children: [
                    IconButton(
                        onPressed: () async {
                          bool shouldClose = await closeComposer();
                          if (shouldClose && mounted)
                            Navigator.of(context).pop();
                          return;
                        },
                        icon: const Icon(Icons.close)),
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
                            child: headlineInput,
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
