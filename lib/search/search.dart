import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ohnost/api.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/search/tags.dart';
import 'package:ohnost/search/projects.dart';
import 'package:ohnost/util.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  @override
  bool get wantKeepAlive => true;

  TextEditingController textController = TextEditingController();

  late List<String> tags = [];
  late List<PostingProject> projects = [];

  searchForThing(String value) async {
    value = value.trim();
    List<PostingProject> projects = await projectQuery(value);
    List<String> tags = await tagQuery(value);

    setState(() {
      this.tags = tags;
      this.projects = projects;
    });
  }

  projectQuery(String value) async {
    var projectEndpoint =
        """$trpcBase/projects.searchByHandle?input={"query":"$value","skipMinimum":false}""";
    var res = await authenticatedGet(Uri.parse(projectEndpoint));
    List<dynamic> json =
        jsonDecode(utf8.decode(res.bodyBytes))['result']['data']['projects'];
    List<PostingProject> projects =
        json.map((value) => PostingProject.fromJson(value)).toList();

    return projects;
  }

  tagQuery(String value) async {
    var tagEndpoint = """$trpcBase/tags.query?input={"query":"$value"}""";
    var res = await authenticatedGet(Uri.parse(tagEndpoint));
    List<dynamic> json =
        jsonDecode(utf8.decode(res.bodyBytes))['result']['data']['result'];
    List<String> result = json.map((e) => e['content'] as String).toList();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    onSubmitted: (value) => searchForThing(value),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        hintText: "looking for something?",
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.surfaceVariant),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (projects.isNotEmpty) ProjectList(projects),
                  if (tags.isNotEmpty) TagList(tags),
                ],
              ),
            ),
          ])),
    );
  }
}

