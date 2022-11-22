import 'package:flutter/widgets.dart';
import 'package:ohnost/src/app.dart';
import 'package:ohnost/src/cohost/model.dart';
import 'package:ohnost/src/components/post/post.dart';

class PostStream extends StatefulWidget {
  final Future<List<Post>> Function(num cursor) postGetter;

  const PostStream({super.key, required this.postGetter});

  @override
  State<StatefulWidget> createState() {
    return PostStreamState();
  }
}

class PostStreamState extends State<PostStream> {
  final num cursor = 0;

  @override
  Widget build(BuildContext context) {
    Future<List<Post>> posts = widget.postGetter(cursor);

    return FutureBuilder<List<Post>>(
        future: posts,
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          List<Widget> children;
          if (snapshot.hasError) {
            children = [Text("aw geeze: ${snapshot.error}")];
          } else if (snapshot.hasData) {
            children = [
              for (var post in snapshot.data!)
                PostView(
                  post: post,
                ),
              GestureDetector(
                onTap: () => {},
                child: Text("please.. more posts"),
              )
            ];
          } else {
            children = [
              const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text(
                  "servin' up your posts, one sec",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colours.stone300,
                      fontStyle: FontStyle.italic),
                ),
              )
            ];
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        });
  }
}
