import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gallery/component/full_image.dart';
import 'package:gallery/component/likes_view.dart';
import 'package:gallery/model/image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCard extends StatelessWidget {
  final PixabayImage pixabayImage;
  const ImageCard({super.key, required this.pixabayImage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => fullPic(context),
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => FullImage(
            pixabayImage: pixabayImage,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.easeInOut));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
              position: DecorationPosition.background,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10.0), // Adjust radius as needed
                  color: Colors.transparent,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(pixabayImage.previewURL))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  //   colorBlendMode: BlendMode.srcOver,
                  imageUrl: pixabayImage.webformatURL,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  // placeholder: (context, url) =>
                  //     CircularProgressIndicator(),
                ),
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: LikesVeiws(
                likes: pixabayImage.likes,
                veiws: pixabayImage.views,
              )),
        ],
      ),
    );
  }

  fullPic(BuildContext ctxt) => showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      context: ctxt,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
            child: FadeTransition(
              opacity: anim1,
              child: child,
            ),
          ),
      pageBuilder: (ctx, anim1, anim2) => Padding(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: pixabayImage.imageWidth / pixabayImage.imageHeight,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              pixabayImage.webformatURL))),
                  child: Image.network(
                    pixabayImage.largeImageURL,
                    fit: BoxFit.contain,

                    // placeholder: (context, url) =>
                    //     CircularProgressIndicator(),
                  )),
            ),
          ));
}
