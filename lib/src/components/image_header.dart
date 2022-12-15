import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:ohnost/src/app.dart';

class ImageHeader extends StatelessWidget {
  final String? imageURl;
  final String title;
  const ImageHeader(this.title, {this.imageURl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: imageURl != null ? 200 : 100,
        color: Colours.purple200,
        child: Stack(
          children: [
            if (imageURl != null)
              Image(
                image: NetworkImage(imageURl!),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              )
          ],
        ));
  }
}
