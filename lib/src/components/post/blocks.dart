import 'package:flutter/widgets.dart';
import 'package:ohnost/src/cohost/model.dart';

class BlocksList extends StatelessWidget {
  final List<Block> blocks;

  const BlocksList({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (var block in blocks) BlockView(block: block)]);
  }
}

class BlockView extends StatelessWidget {
  final Block block;

  const BlockView({required this.block, super.key});

  @override
  Widget build(BuildContext context) {
    if (block.typeGood == BlockType.markdown) {
      return (Text(block.markdown!.content));
    } else {
      return (Text("hey"));
    }
  }
}
