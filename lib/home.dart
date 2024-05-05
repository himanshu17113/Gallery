import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gallery/component/image_card.dart';
import 'package:gallery/domain/repository/pixabay_repository.dart';
import 'package:gallery/model/image.dart';

import 'domain/debouncer.dart';

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
  bool noMoreData = false;
  bool noSearchFound = false;
  final Debouncer _debouncer = Debouncer();
  @override
  void initState() {
    super.initState();
    PixabayRepository.getPixabay(q, page).then((value) => setState(() {
          noMoreData = false;
          noSearchFound = false;
          pixabayImages.addAll(value);
        }));

    scrollController.addListener(() async {
      if ((scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.8 &&
          !isLoading)) {
        isLoading = true;

        PixabayRepository.getPixabay(q, ++page, fast: false)
            .then((value) => setState(() {
                  noMoreData = false;
                  noSearchFound = false;
                  if (value.isEmpty) {
                    noMoreData = true;
                  }
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
      case < 400:
        return 1;
      default:
        return 4;
    }
  }

  debouncedSearch(String searchTerm, Function(String) callback,
      {int waitTime = 500}) {
    Timer? timeout;

    void inner(String newSearchTerm) {
      timeout?.cancel();
      timeout = Timer(Duration(milliseconds: waitTime), () {
        if (searchTerm != newSearchTerm) {
          callback(newSearchTerm);
          searchTerm = newSearchTerm;
        }
      });
    }

    // Call the inner function initially to handle immediate search
    inner(searchTerm);

    // Return a function to remove the listener if needed
    return () {
      timeout?.cancel();
    };
  }

  search(String text) async {
    q = text;
    noMoreData = false;
    noSearchFound = false;
    page = 1;

    isLoading = true;
    //  if (!isLoading) {
    await PixabayRepository.getPixabay(q, 1).then((value) => setState(() {
          if (value.isEmpty) {
            noSearchFound = true;
          } else if (value.length < 12) {
            noMoreData = true;
          }
          pixabayImages = value;
          isLoading = false;
        }));
    if (!noSearchFound && scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 3,
                            child: FittedBox(
                              child: Text("Gallery",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87)),
                            )),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 12,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            //  cursorHeight: 18,
                            cursorColor: Colors.grey,
                            cursorOpacityAnimates: true,

                            cursorWidth: 1.5,
                            cursorRadius: const Radius.circular(2),
                            onChanged: (value) => _debouncer(() {
                              search(value);
                            }),
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(24, 8, 12, 10),
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
                          flex: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
        body: noSearchFound
            ? Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(80),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(":(",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 48.0,
                          )),
                      Text(
                        " OOPS!",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Images Not Found",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final int columnCount =
                      _calculateColumnCount(constraints.maxWidth);
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
                    itemBuilder: (context, index) =>
                        index == pixabayImages.length
                            ? noMoreData
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(80),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(":(",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 48.0,
                                              )),
                                          Text(
                                            " Sorry, No More Data Available",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.black12,
                                  )
                            : ImageCard(pixabayImage: pixabayImages[index]),
                  );
                },
              ));
  }
}
