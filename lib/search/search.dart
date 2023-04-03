import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ohnost/api.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/search/project_entry.dart';
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
    List<PostingProject> projects = await projectQuery(value);

    setState(() {
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

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
          ])),
    );
  }
}

class ProjectList extends StatelessWidget {
  const ProjectList(this.projects, {super.key});

  final List<PostingProject> projects;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pages", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(
            height: 8,
          ),
          for (var project in projects) ProjectEntry(project),
        ],
      ),
    );
  }
}
