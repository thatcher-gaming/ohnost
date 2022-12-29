import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/poststream.dart';
import 'package:ohnost/secrets.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

import 'composer.dart';
import 'main.dart';

class ProfileView extends StatelessWidget {
  final String handle;
  const ProfileView(this.handle, {super.key});

  @override
  Widget build(BuildContext context) {
    Future<Tuple2<PostingProject, List<Post>>> profileFuture =
        PostingProject.getUserData(handle);

    List<Widget> profileActions;
    if (handle == AppSecrets.currentProjectHandle) {
      profileActions = [
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Routemaster.of(context).push("/settings");
          },
        )
      ];
    } else {
      profileActions = [
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {},
        ),
      ];
    }

    return Scaffold(
      floatingActionButton: handle == AppSecrets.currentProjectHandle
          ? FloatingActionButton(
              onPressed: () => PostComposer.showComposeDialog(context),
              child: const Icon(Icons.add))
          : null,
      body: FutureBuilder(
        future: profileFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PostingProject profile = snapshot.data!.item1;
            return PostStream(
              postGetter: (cursor, _) =>
                  PostList.fromUser(handle, cursor: cursor).postFuture,
              incrementCursorBy: 1,
              appBar: SliverAppBar.large(
                title: _PageTitle(profile: profile),
                actions: profileActions,
                backgroundColor: Theme.of(context).colorScheme.surface,
                centerTitle: true,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              snapshot.error.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({
    required this.profile,
  });

  final PostingProject profile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Semantics(
                hidden: true,
                child: CachedNetworkImage(
                  imageUrl: profile.avatarPreviewURL,
                  cacheManager: cacheManager,
                  width: 36,
                  height: 36,
                ))),
        Text("@${profile.handle}"),
      ],
    );
  }
}
