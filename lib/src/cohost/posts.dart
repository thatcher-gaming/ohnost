import 'dart:convert';

import 'package:http/http.dart';
import 'package:ohnost/src/cohost/api.dart';
import 'package:ohnost/src/cohost/model.dart';

class PostGetter {
  final String handle;

  PostGetter({required this.handle});

  Future<List<Post>> getPosts() async {
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
}
