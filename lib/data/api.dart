import 'package:http/http.dart' as http;

class Api {
  static const String key = '27903160-33fb8fe3da3e02b05a82f6cb4';

  ///
  static Future<http.Response> pixabayApi(String query, int page) async => http.get(
      Uri.parse(
          "https://pixabay.com/api/?key=${key}&q=$query&image_type=photo&pretty=true&page=$page"),
      headers: {'Content-Type': 'text/plain'});
}
