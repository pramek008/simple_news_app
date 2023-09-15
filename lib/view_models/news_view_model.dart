import 'package:exam_consume_api/models/NewsCategoriesModel.dart';
import 'package:exam_consume_api/models/NewsHeadlinesModel.dart';
import 'package:exam_consume_api/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsHeadlinesModel> fetchNewsHeadlinesApi(String channelName) async {
    final response = await _rep.fethNewsHeadlinesApi(channelName);
    return response;
  }

  Future<NewsCategoriesModel> fetchNewsCategoriesApi(String category) async {
    final response = await _rep.fethNewsCategoriesApi(category);
    return response;
  }
}
