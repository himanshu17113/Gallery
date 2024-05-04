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

  int _calculateColumnCount(final double screenWidth) {
    switch (screenWidth) {
      case double.infinity:
        return 4; // Default value for very large screens
      case < 600:
        return 2;
      case >= 600 && < 1200:
        return 3;
      default:
        return 4;
    }
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final int columnCount = _calculateColumnCount(screenWidth);
            return GridView.builder(
              padding: const EdgeInsets.all(15),
              controller: scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                  crossAxisCount: columnCount),
              itemCount: pixabayImages.length,
              itemBuilder: (context, index) =>
                  ImageCard(pixabayImage: pixabayImages[index]),
            );
          },
        ));
  }
}
