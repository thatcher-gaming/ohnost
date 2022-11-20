import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ohnost/src/app.dart';
import 'package:ohnost/src/cohost/model.dart' as model;

class BlocksList extends StatelessWidget {
  final List<model.Block> blocks;

  const BlocksList({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (var block in blocks) BlockView(block: block)]);
  }
}

class BlockView extends StatelessWidget {
  final model.Block block;

  const BlockView({required this.block, super.key});

  @override
  Widget build(BuildContext context) {
    if (block.typeGood == model.BlockType.markdown) {
      // return Text("hi");
      return (Markdown(
        data: block.markdown!.content,
        padding: const EdgeInsets.all(0),
        styleSheet: MarkdownStyleSheet.fromTheme(Application.theme),
        selectable: true,
        softLineBreak: true,
        controller: Application.scrollControl,
        shrinkWrap: true,
      ));
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: (Image(
            image: NetworkImage(block.attachment!.previewURL),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          )),
        ),
      );
    }
  }
}
