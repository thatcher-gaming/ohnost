import 'package:flutter/widgets.dart';
import 'package:ohnost/src/cohost/model.dart';

class PostView extends StatelessWidget {
  final Post post;

  const PostView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Text(post.headline);
  }
}
