import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsService {
  static const String baseUrl =
      'https://api.zapp.software/news';

  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((e) => News.fromJson(e)).toList();
    } else {
      throw Exception('Gagal load news');
    }
  }
}