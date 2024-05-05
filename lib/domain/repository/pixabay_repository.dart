import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gallery/model/image.dart';
import '../../data/api.dart';

class PixabayRepository extends Api {
  static Future<List<PixabayImage>> getPixabay(String text, int page,
      {bool fast = true}) async {
    // final queryParameters = {
    //   'key': '27903160-33fb8fe3da3e02b05a82f6cb4',
    //   'q': text,
    //   'image_type': 'photo',
    //   'per_page': 1
    // };
    debugPrint("api hit");

    final response = await Api.pixabayApi(text, page, fast);

    // ignore: non_constant_identifier_names
    var JsonResponse = <String, dynamic>{};

    if (response.statusCode == 200) {
      JsonResponse = jsonDecode(response.body);
    } else {
      debugPrint('Issue in api request');
    }

    final List hits = JsonResponse['hits'];

    final images = hits.map(
      (e) {
        return PixabayImage.fromMap(e);
      },
    ).toList();
    return images;
  }
}
