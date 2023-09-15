import 'dart:convert';

import 'package:exam_consume_api/models/NewsCategoriesModel.dart';
import 'package:exam_consume_api/models/NewsHeadlinesModel.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<NewsHeadlinesModel> fethNewsHeadlinesApi(String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=87354000870e4c82a401d01aa2ba3f69';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // print(response.body);
      final body = json.decode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<NewsCategoriesModel> fethNewsCategoriesApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=87354000870e4c82a401d01aa2ba3f69';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.body);
      final body = json.decode(response.body);
      return NewsCategoriesModel.fromJson(body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
