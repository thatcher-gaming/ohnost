import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/posts/user_info.dart';
import 'package:routemaster/routemaster.dart';

class ProjectEntry extends StatelessWidget {
  const ProjectEntry(this.project, {super.key});

  final PostingProject project;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),
        foregroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.onSurface));

    return Card(
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: () {
          Routemaster.of(context).push("/profile/${project.handle}");
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ProfilePicture(
                    project.avatarPreviewURL,
                    height: 56,
                    width: 56,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (project.displayName != null)
                        Text(
                          project.displayName!.length <= 24 ?
                          project.displayName! :
                          "${project.displayName!.substring(0, 24)}…",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      Text(
                        "@${project.handle}",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_add_outlined),
                style: buttonStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
