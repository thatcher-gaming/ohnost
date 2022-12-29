import 'package:cached_network_image/cached_network_image.dart';
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
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: (CachedNetworkImage(
            imageUrl: block.attachment!.previewURL,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )),
        ),
      );
    } else {
      return const Text("Unsupported media type");
    }
  }
}
