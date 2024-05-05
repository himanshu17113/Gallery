import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gallery/component/image_card.dart';
import 'package:gallery/domain/repository/pixabay_repository.dart';
import 'package:gallery/model/image.dart';

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
              scrollController.position.maxScrollExtent * 0.8 &&
          !isLoading)) {
        isLoading = true;
        PixabayRepository.getPixabay(q, ++page, fast: false)
            .then((value) => setState(() {
                  pixabayImages.addAll(value);

                  isLoading = false;
                }));
      }
    });
  }

  int _calculateColumnCount(final double screenWidth) {
    switch (screenWidth) {
      case double.infinity:
        return 4; // Default value for very large screens
      case < 600 && > 400:
        return 2;
      case >= 600 && < 1200:
        return 3;
      case < 300:
        return 1;
      default:
        return 4;
    }
  }

  search(String text) async {
    q = text;
    page = 1;
    scrollController.jumpTo(0);
    isLoading = true;
    pixabayImages = await PixabayRepository.getPixabay(q, 1);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: ClipRect(
              clipBehavior: Clip.hardEdge,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10.0, sigmaY: 30.0, tileMode: TileMode.mirror),
                child: ColoredBox(
                  color: const Color.fromARGB(150, 250, 250, 250),
                  child: SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        children: [
                          const Spacer(flex: 1),
                          Expanded(
                              flex: 1,
                              child: Text("Gallery",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontWeight: FontWeight.w600))),
                          const Spacer(flex: 1),
                          Expanded(
                            flex: 6,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              cursorHeight: 20,
                              cursorColor: const Color(0xFF656F79),
                              cursorRadius: const Radius.circular(2),
                              onChanged: (value) => search(value),
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  //  const Color.fromARGB(255, 237, 237, 237),
                                  filled: true,
                                  hintText: "Search",
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(33),
                                      borderSide: BorderSide.none),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(33),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(33),
                                      borderSide: BorderSide.none),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(33),
                                      borderSide: BorderSide.none),
                                  suffix: TextButton(
                                      onPressed: () => search(q),
                                      child: const Text("Find",
                                          style: TextStyle(
                                            color: Color(0xFF656F79),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )))),
                              //     onSubmitted: (text) => search(text),
                            ),
                          ),
                          const Spacer(
                            flex: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final int columnCount = _calculateColumnCount(constraints.maxWidth);
            return GridView.builder(
              cacheExtent: 500,
              padding: const EdgeInsets.all(14),
              controller: scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 12.5,
                  crossAxisSpacing: 12.5,
                  childAspectRatio: 1,
                  crossAxisCount: columnCount),
              itemCount: pixabayImages.length + 1,
              itemBuilder: (context, index) => index == pixabayImages.length
                  ? const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.black12,
                    )
                  : ImageCard(pixabayImage: pixabayImages[index]),
            );
          },
        ));
  }
}
