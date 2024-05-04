import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery/model/image.dart';

import 'likes_view.dart';

class FullImage extends StatelessWidget {
  final PixabayImage pixabayImage;
  const FullImage({super.key, required this.pixabayImage});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          pixabayImage.webformatURL))),
              child: Image.network(
                //   colorBlendMode: BlendMode.srcOver,
                pixabayImage.largeImageURL,
                fit: BoxFit.cover,

                // placeholder: (context, url) =>
                //     CircularProgressIndicator(),
              )),
          const Positioned(
            top: 20,
            left: 20,
            child: BackButton(
              color: Colors.white,
            ),
          ),
          Positioned(
              bottom: 5,
              right: 5,
              child: LikesVeiws(
                likes: pixabayImage.likes,
                veiws: pixabayImage.views,
              )),
        ],
      ),
    );
  }
}
