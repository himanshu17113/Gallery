import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List<PixabayImage> PixabayImages = [];

  Future<void> fetchImages(String text) async {
    final response = await Dio().get(
      'https://pixabay.com/api',
      queryParameters: {
        'key': '29968620-72dcc6bcaf760fb9d8a108fbe',
        'q': text,
        'image_type': 'photo',
        'per_page': 100
      },
    );
    final List hits = response.data['hits'];
    PixabayImages = hits.map(
      (e) {
        return PixabayImage.fromMap(e);
      },
    ).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchImages('花');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: '花',
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: PixabayImages.length,
        itemBuilder: (context, index) {
          final PixabayImage = PixabayImages[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                PixabayImage.previewURL,
                fit: BoxFit.cover,
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
                        Text('${PixabayImage.likes}'),
                      ],
                    )),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PixabayImage {
  final String webformatURL;
  final String previewURL;
  final int likes;

  PixabayImage(
      {required this.webformatURL,
      required this.previewURL,
      required this.likes});

  factory PixabayImage.fromMap(Map<String, dynamic> map) {
    return PixabayImage(
      webformatURL: map['webformatURL'],
      previewURL: map['previewURL'],
      likes: map['likes'],
    );
  }
}
