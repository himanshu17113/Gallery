import 'package:http/http.dart' as http;

class Api {
  static const String key = '27903160-33fb8fe3da3e02b05a82f6cb4';

  ///
  static Future<http.Response> pixabayApi(
          String query, int page, bool fast) async =>
      http.get(
          Uri.parse(
              "https://pixabay.com/api/?key=$key&q=$query&image_type=photo&pretty=true&page=$page&per_page=${fast ? 12 : 24} "),
          headers: {'Content-Type': 'text/plain'});
}
