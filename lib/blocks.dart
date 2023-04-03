import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ohnost/model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

const truncateLength = 2;

class BlocksView extends StatelessWidget {
  final Post? post;
  late final List<Block> blocks;
  final ScrollController scrollControllerLocal = ScrollController();
  final bool truncate;

  BlocksView(this.blocks, {super.key, this.post, this.truncate = false});
  BlocksView.frompost(this.post, {super.key, this.truncate = false}) {
    blocks = post!.blocks;
  }

  @override
  Widget build(BuildContext context) {
    // RegExp formatRegex = RegExp(
    //     r"(?:(?:https?)+\:\/\/+.)+(?:(?:jpe?g|png|gif))");
    List<Block> attachments = blocks
        .where((element) => (element.typeGood == BlockType.attachment))
        .toList();

    List<Block>? truncated;
    bool readMore = false;

    if (truncate) {
      // we only want to truncate based on the markdown blocks
      var markdownLen = blocks
          .where((element) => element.typeGood == BlockType.markdown)
          .length;
      if (markdownLen > truncateLength) {
        truncated = blocks.sublist(0, truncateLength);
        readMore = true;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post != null)
          if (post!.headline != "")
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Text(post!.headline,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
        if (attachments.isNotEmpty) ImageView(attachments),
        for (var block in truncated ?? blocks)
          BlockView(
            block,
            controller: scrollControllerLocal,
          ),
        if (readMore && post != null)
          ReadMoreButton(
            post!.postingProject.handle,
            post!.postId,
          )
      ],
    );
  }
}

class ReadMoreButton extends StatelessWidget {
  const ReadMoreButton(this.handle, this.id, {super.key});

  final String handle;
  final int id;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Routemaster.of(context).push("/post/$handle/$id");
      },
      icon: const Icon(Icons.expand_more),
      label: const Text("Read More"),
    );
  }
}

class BlockView extends StatelessWidget {
  final Block block;
  final ScrollController controller;

  const BlockView(this.block, {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (block.typeGood == BlockType.markdown) {
      RegExp htmlRe =
          RegExp(r"(<(.*)>(.*)</([^br][A-Za-z0-9]+)>)", caseSensitive: false);
      bool isHTML = htmlRe.hasMatch(block.markdown!.content);
      Widget widgetToReturn = isHTML
          ? HtmlWidget(
              block.markdown!.content,
              onTapUrl: (p0) async {
                if (await canLaunchUrl(Uri.parse(p0))) {
                  launchUrl(Uri.parse(p0),
                      mode: LaunchMode.externalApplication);
                }
                return true;
              },
            )
          : Markdown(
              data: block.markdown!.content,
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              selectable: true,
              softLineBreak: true,
              controller: controller,
              shrinkWrap: true,
              onTapLink: (text, href, title) async {
                print(href);
                launchUrl(Uri.parse(href!),
                    mode: LaunchMode.externalApplication);
              },
              styleSheet: MarkdownStyleSheet(textScaleFactor: 1.2));
      return widgetToReturn;
    } else if (block.typeGood == BlockType.attachment) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return const Text("Unsupported media type");
    }
  }
}

class ImageView extends StatelessWidget {
  const ImageView(
    this.attachments, {
    super.key,
  });

  final List<Block> attachments;

  void showImageViewer(BuildContext context) {
    MultiImageProvider multiImageProvider = MultiImageProvider([
      for (var attachment in attachments)
        Image.network(attachment.attachment!.fileURL).image,
    ]);
    showImageViewerPager(context, multiImageProvider, onPageChanged: (page) {
      print("page changed to $page");
    }, onViewerDismissed: (page) {
      print("dismissed while on page $page");
    });
  }

  @override
  Widget build(BuildContext context) {
    double optimalWidth = MediaQuery.of(context).size.width;
    double optimalHeighth = MediaQuery.of(context).size.height;
    return Column(
      children: [
        for (var block in attachments)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: GestureDetector(
              onTap: () => showImageViewer(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: CachedNetworkImage(
                    imageUrl:
                        "${block.attachment!.previewURL}?dpr=2&width=$optimalWidth",
                    width: double.infinity,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
