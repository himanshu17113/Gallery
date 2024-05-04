import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery/domain/repository/pixabay_repository.dart';
import 'package:gallery/model/image.dart';
import 'package:transparent_image/transparent_image.dart';

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List<PixabayImage> pixabayImages = [];
  ScrollController scrollController = ScrollController();
  String q = '';
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    super.initState();
    PixabayRepository.getPixabay(q, page)
        .then((value) => setState(() => pixabayImages.addAll(value)));

    scrollController.addListener(() async {
      if ((scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading)) {
        isLoading = true;
        PixabayRepository.getPixabay(q, ++page)
            .then((value) => pixabayImages.addAll(value));
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            initialValue: '',
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
            onFieldSubmitted: (text) async {
              q = text;
              page = 1;
              scrollController.jumpTo(0);
              pixabayImages = await PixabayRepository.getPixabay(q, 1);

              setState(() {});
            },
          ),
        ),
        body: GridView.builder(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: pixabayImages.length,
          itemBuilder: (context, index) {
            final PixabayImage pixabayImage = pixabayImages![index];
            return Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(pixabayImage.previewURL))),
                  child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
          
                    // colorBlendMode: BlendMode.saturation,
                    // placeholderColorBlendMode: BlendMode.srcOver,
                    // color: Colors.black12,
                    image: pixabayImage.webformatURL,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 14,
                          ),
                          Text('${pixabayImage.likes}'),
                        ],
                      )),
                ),
              ],
            );
          },
        ));
  }
}
