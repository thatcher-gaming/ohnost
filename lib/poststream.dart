import 'package:flutter/material.dart';
import 'package:ohnost/model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'posts/main.dart';

class PostStream extends StatefulWidget {
  final Future<List<Post>> Function(int cursor, int limit, [int? timestamp]) postGetter;
  final int incrementCursorBy;
  final int initalCursor;
  final Widget titleWidget;
  final Widget? appBar;

  PostStream(
      {super.key,
      required this.postGetter,
      this.incrementCursorBy = 25,
      this.initalCursor = 0,
      this.appBar,
      this.titleWidget = const Text("My Post Stream")});

  @override
  State<PostStream> createState() => _PostStreamState();
}

// FIXME: this entire class a huge hack that will destroy my psyche at some point down the road
class _PostStreamState extends State<PostStream> {
  bool loadingMorePages = false;
  List<Post> posts = [];
  late int cursor;

  @override
  void initState() {
    super.initState();
    cursor = widget.initalCursor;
  }

  void loadNextPage() async {
    setState(() {
      loadingMorePages = true;
      cursor = cursor + widget.incrementCursorBy;
    });

    int? refTimestamp = DateTime.tryParse(posts.last.publishedAt)?.millisecondsSinceEpoch;

    List<Post> nextPage = await widget.postGetter(cursor, 25, refTimestamp);

    setState(() {
      loadingMorePages = false;
      posts = [...posts, ...nextPage];
    });
  }

  SliverChildDelegate postStreamDelegate() {
    return SliverChildBuilderDelegate((context, index) {
      if (index < posts.length) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: PostView(
            post: posts[index],
            truncate: true,
          ),
        );
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        if (widget.appBar != null)
          widget.appBar!
        else
          SliverAppBar.large(
            title: widget.titleWidget,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.vertical_align_top),
                onPressed: () => scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOutCubicEmphasized,
                ),
              )
            ],
          ),
        FutureBuilder(
          future: widget.postGetter(0, widget.incrementCursorBy),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.hasData) {
              if (posts.isEmpty) posts = snapshot.data!;
              child = SliverList(delegate: postStreamDelegate());
            } else {
              child = const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()));
            }
            return child;
          },
        ),
        SliverFillRemaining(
          fillOverscroll: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxHeight <= 100) {
                return Container();
              }
              return AnimatedOpacity(
                opacity: constraints.maxHeight >= 150 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Center(
                    child: FilledButton.icon(
                  onPressed: () => loadNextPage(),
                  icon: loadingMorePages
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(PhosphorIcons.caretDown),
                  label: const Text("next page please!"),
                )),
              );
            },
          ),
        )
      ],
    );
  }
}
