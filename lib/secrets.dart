import 'dart:convert';
import 'dart:io';

import 'package:ohnost/api.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSecrets {
  static const String cookie = "";
  static PostingProject? currentProject;
  static List<PostingProject>? editableProjects;
  static const String currentProjectHandle = "leah";

  static Future<PostingProject> getSelf() async {
    if (AppSecrets.currentProject != null) return AppSecrets.currentProject!;

    var projects = await AppSecrets.getEditableProjects();

    var res = await authenticatedGet(Uri.parse("$trpcBase/login.loggedIn"));
    int projectId =
        jsonDecode(utf8.decode(res.bodyBytes))['result']['data']['projectId'];
    var project =
        projects.firstWhere((element) => element.projectId == projectId);

    AppSecrets.currentProject = project;
    return project;
  }

  static Future<List<PostingProject>> getEditableProjects() async {
    if (AppSecrets.editableProjects != null)
      return AppSecrets.editableProjects!;
    var res = await authenticatedGet(
        Uri.parse("$trpcBase/projects.listEditedProjects"));
    List<dynamic> json =
        jsonDecode(utf8.decode(res.bodyBytes))['result']['data']['projects'];
    List<PostingProject> projects =
        json.map((e) => PostingProject.fromJson(e)).toList();
    AppSecrets.editableProjects = projects;
    return projects;
  }
}
