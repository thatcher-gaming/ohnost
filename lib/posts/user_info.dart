import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ohnost/posts/date.dart';
import 'package:ohnost/posts/main.dart';
import 'package:routemaster/routemaster.dart';

import '../main.dart';
import '../model.dart';

class UserInfoPart extends StatelessWidget {
  final PostingProject user;
  final String? date;

  const UserInfoPart(this.user, {super.key, this.date});

  @override
  Widget build(BuildContext context) {
    List<Widget> children;
    if (user.displayName is String) {
      children = [
        Text(user.displayName!),
        Text(
          "@${user.handle}",
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        )
      ];
    } else {
      children = [
        Text("@${user.handle}"),
      ];
    }
    return Wrap(children: [
      TextButton(
          onPressed: () {
            Routemaster.of(context).push("/profile/${user.handle}");
          },
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              shape: const MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              textStyle: MaterialStatePropertyAll(
                  Theme.of(context).textTheme.titleMedium),
              foregroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.onSurface)),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            children: [
              ProfilePicture(user.avatarPreviewURL),
              Wrap(
                spacing: 8,
                children: children,
              ),
              if (date != null) DateView(date!),
            ],
          )),
      const SizedBox(
        width: double.infinity,
      ),
    ]);
  }
}

class EmbiggenedUserInfo extends StatelessWidget {
  final PostingProject user;
  final String date;

  const EmbiggenedUserInfo(this.user, {required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    var children = user.displayName != null
        ? <Widget>[
            Text(
              user.displayName!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "@${user.handle}",
              style: Theme.of(context).textTheme.titleSmall,
            )
          ]
        : <Widget>[Text("@${user.handle}")];

    return GestureDetector(
      onTap: () => Routemaster.of(context).push("/profile/${user.handle}"),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePicture(
              user.avatarPreviewURL,
              height: 48,
              width: 48,
              borderRadius: BorderRadius.circular(12),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Wrap(
                direction: Axis.vertical,
                children: children,
              ),
            ),
            const Spacer(),
            DateView(date)
          ],
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final String uri;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ProfilePicture(this.uri,
      {super.key, this.width = 22, this.height = 22, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      child: Semantics(
        hidden: true,
        child: CachedNetworkImage(
          imageUrl: "$uri?dpr=2&width=$width&height=$height&fit=cover",
          cacheManager: cacheManager,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
