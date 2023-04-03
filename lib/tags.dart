import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:ohnost/poststream.dart';
import 'package:ohnost/secrets.dart';
import 'package:ohnost/util.dart';
import 'package:tuple/tuple.dart';

import "model.dart";

class TagPage extends StatefulWidget {
  TagPage(String tagName, {super.key}) {
    tag = Tag(tagName);
  }
  TagPage.fromTag(this.tag, {super.key});

  late Tag tag;

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  late Tag tag;
  @override
  Widget build(BuildContext context) {
    setState(() {
      tag = widget.tag;
    });
    return Scaffold(
      body: PostStream(
        titleWidget: Text("#${widget.tag.tag}"),
        postGetter: (cursor, limit) => widget.tag.getItems(cursor),
      ),
    );
  }
}

class Tag {
  const Tag(this.tag);

  final String tag;

  Future<List<Post>> getItems(int cursor) async {
    try {
      final Uri endpoint =
          Uri.parse("https://cohost.org/rc/tagged/$tag?skipPosts=$cursor");
      Response res = await authenticatedGet(endpoint);

      if (res.statusCode == 200) {
        List<dynamic> postList = await extractLoaderState(
          utf8.decode(res.bodyBytes),
          'tagged-post-feed',
        );

        List<Post> posts =
            postList.map((dynamic item) => Post.fromJson(item)).toList();
        return posts;
      } else {
        throw "status code ${res.statusCode}";
      }
    } catch (e) {
      return Future.error(e.toString());
    }
    throw UnimplementedError();
  }
}
