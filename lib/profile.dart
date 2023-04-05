import 'package:flutter/material.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/posts/user_info.dart';
import 'package:ohnost/poststream.dart';
import 'package:ohnost/secrets.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class ProfileView extends StatefulWidget {
  final String handle;
  const ProfileView(this.handle, {super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin<ProfileView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Future<Tuple2<PostingProject, List<Post>>> profileFuture =
        PostingProject.getUserData(widget.handle);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      floatingActionButton: widget.handle == AppSecrets.currentProjectHandle
          ? FloatingActionButton(
              heroTag: "btn2",
              onPressed: () => Routemaster.of(context).push('/compose'),
              child: const Icon(Icons.add))
          : null,
      body: FutureBuilder(
        future: profileFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PostingProject profile = snapshot.data!.item1;
            List<Widget> profileActions;
            if (widget.handle == AppSecrets.currentProjectHandle) {
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
                FollowButton(profile),
              ];
            }

            return PostStream(
              postGetter: (cursor, _, [timestamp]) =>
                  PostList.fromUser(widget.handle, cursor: cursor).postFuture,
              incrementCursorBy: 1,
              appBar: SliverAppBar.large(
                title: _PageTitle(profile: profile),
                actions: profileActions,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
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

class FollowButton extends StatefulWidget {
  const FollowButton(
    this.profile, {
    super.key,
  });

  final PostingProject profile;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late Future<FollowStatus> followStatus;
  late bool isFollowing;
  @override
  initState() {
    super.initState();
    followStatus = widget.profile.getFollowStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: followStatus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FollowStatus followStatus = snapshot.data!;
          return IconButton(
            icon: followStatus.readerToProject == 0
                ? const Icon(Icons.person_add)
                : const Icon(Icons.person_remove),
            onPressed: () {},
          );
        } else {
          return const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(),
          );
        }
      },
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
              child: ProfilePicture(
                profile.avatarPreviewURL,
                width: 36,
                height: 36,
                borderRadius: BorderRadius.circular(8),
              )),
        ),
        Text("@${profile.handle}"),
      ],
    );
  }
}
