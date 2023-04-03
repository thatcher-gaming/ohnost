import 'package:flutter/material.dart';

class DiscardAlert extends StatelessWidget {
  final Function(bool outcome) close;
  final bool comment;

  const DiscardAlert(this.close, {super.key, this.comment = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Discard this ${comment ? "comment" : "post"}?"),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      icon: const Icon(Icons.warning),
      content: Text(
          "You won't be able to get this ${comment ? "comment" : "post"} back if you discard it."),
      actions: [
        TextButton(
            onPressed: () {
              close(true);
              Navigator.of(context).pop();
            },
            child: const Text("Discard")),
        TextButton(
            onPressed: () {
              close(false);
              Navigator.of(context).pop();
            },
            child: const Text("Keep Writing")),
      ],
    );
  }
}
