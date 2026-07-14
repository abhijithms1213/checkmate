import 'package:checkmate/core/constants/constants.dart';
import 'package:checkmate/features/news/data/models/article_model.dart';
import 'package:dio/dio.dart';

class NewsApiService {
  final Dio _dio;

  NewsApiService(this._dio);

  Future<List<ArticleModel>> getNewsArticles() async {
    try {
      final response = await _dio.get(
        '$newsbaseApiUrl/category/health/in.json',
      );

      final articles = response.data['articles'] as List;

      return articles
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      );
    }
  }
}
