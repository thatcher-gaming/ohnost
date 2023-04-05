import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:ohnost/secrets.dart';

authenticatedGet(Uri uri) async {
  if (AppSecrets.cookie.isEmpty) throw Error();
  return await get(uri,
      headers: {'Cookie': 'connect.sid=${AppSecrets.cookie}'});
}

authenticatedPost(Uri uri, {Object? body}) async {
  return await post(uri,
      headers: {
        'Cookie': 'connect.sid=${AppSecrets.cookie}',
        'Content-Type': 'application/json'
      },
      body: body);
}

authenticatedDelete(Uri uri) async {
  return await delete(uri,
      headers: {'Cookie': 'connect.sid=${AppSecrets.cookie}'});
}

/// hey so this is kinda weird.
/// cohost has this fun thing where their api isn't documented anywhere,
/// so it's hard to tell where exactly to look if you want to, say,
/// get the home feed if it's being rendered on the server instead of
/// in-browser (where you can just check the network tab in devtools).
/// luckily, most post streams in cohost have a "\_\_COHOST_LOADER_STATE\_\_"
/// element containing the contents of the stream in json, which is what
/// we're doing here. if any cohost staff are reading this please don't
/// break this cheers god bless
Future<List<dynamic>> extractLoaderState(String document, String object) async {
  final Document parsed = parse(document);
  final Element elem = parsed.getElementById("__COHOST_LOADER_STATE__")!;
  final Map<String, dynamic> json = jsonDecode(elem.innerHtml);
  Map<String, dynamic> dashObject = json[object];
  List<dynamic> postList = dashObject['posts'];

  return postList;
}
