import 'package:flutter/widgets.dart';
import 'package:ohnost/src/cohost/model.dart';
import 'package:ohnost/src/components/image_header.dart';
import 'package:ohnost/src/components/layouts.dart';
import 'package:ohnost/src/components/section_header.dart';
import 'package:tuple/tuple.dart';

class UserPage extends StatelessWidget {
  final String handle;
  late final PostingProject project;
  late final List<Post> posts;
  late final Future<Tuple2<PostingProject, List<Post>>> response =
      PostingProject.getUserData(handle);

  UserPage(this.handle, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: response,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("aw geeze. ${snapshot.error}");
          } else if (snapshot.hasData) {
            project = snapshot.data!.item1;
            posts = snapshot.data!.item2;
            return Layout(
                header: ImageHeader(
                  project.displayName ?? project.handle,
                  // backButtonVisible: true,
                  // subtitle: project.displayName != null ? "@$handle" : null,
                  imageURl: project.headerPreviewURL,
                ),
                content: Text("hi"));
          } else {
            return const Base([Text("one sec")]);
          }
        });
  }
}
