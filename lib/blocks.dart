import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ohnost/model.dart';
import 'package:url_launcher/url_launcher.dart';

class BlocksView extends StatelessWidget {
  final Post? post;
  late final List<Block> blocks;
  final ScrollController scrollControllerLocal = ScrollController();

  BlocksView(this.blocks, {super.key, this.post});
  BlocksView.frompost(this.post, {super.key}) {
    blocks = post!.blocks;
  }

  @override
  Widget build(BuildContext context) {
    RegExp formatRegex = RegExp(
        r"(?:(?:https?)+\:\/\/+[a-zA-Z0-9\/\._-]{1,})+(?:(?:jpe?g|png|gif))");
    List<Block> attachments = blocks
        .where((element) => (element.typeGood == BlockType.attachment))
        .toList();

    List<Block> attachmentsFiltered = attachments
        .where(
          (element) => formatRegex.hasMatch(element.attachment!.fileURL),
        )
        .toList();
    attachmentsFiltered.forEach((element) {
      print(element.attachment!.fileURL);
    });

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
        if (attachmentsFiltered.isNotEmpty) ImageView(attachmentsFiltered),
        for (var block in blocks)
          BlockView(
            block,
            controller: scrollControllerLocal,
          )
      ],
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
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: CachedNetworkImage(
                    imageUrl: block.attachment!.previewURL,
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
