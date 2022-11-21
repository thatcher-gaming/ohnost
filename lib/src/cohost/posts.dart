import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:ohnost/src/app.dart';
import 'package:ohnost/src/cohost/api.dart';
import 'package:ohnost/src/cohost/model.dart';

class PostQueries {
  Future<List<Post>> getPostsFromUser(String handle) async {
    try {
      final Uri endpoint = Uri.parse("$apiBase/project/$handle/posts?page=0");
      Response res = await get(endpoint);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(res.body);
        List<dynamic> postList = body['items'];

        // throw UnimplementedError();

        List<Post> posts =
            postList.map((dynamic item) => Post.fromJson(item)).toList();

        return posts;
      } else {
        throw "status code ${res.statusCode}";
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<List<Post>> getHomeFeed(num skip) async {
    try {
      final Uri endpoint = Uri.parse("https://cohost.org/?skipPosts=$skip");
      Response res = await get(endpoint,
          headers: {'Cookie': 'connect.sid=${Application.authCookie}'});

      if (res.statusCode == 200) {
        final Document parsed = parse(utf8.decode(res.bodyBytes));
        final Element elem = parsed.getElementById("__COHOST_LOADER_STATE__")!;
        final Map<String, dynamic> json = jsonDecode(elem.innerHtml);
        Map<String, dynamic> dashObject =
            json['dashboard'] ?? json['dashboard-nonlive-post-feed'];
        List<dynamic> postList = dashObject['posts'];

        List<Post> posts =
            postList.map((dynamic item) => Post.fromJson(item)).toList();
        return posts;
      } else {
        throw "status code ${res.statusCode}";
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
