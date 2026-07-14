import 'dart:io';

import 'package:checkmate/core/resources/data_state.dart';
import 'package:checkmate/features/news/data/data_sources/remote/news_api_service.dart';
import 'package:checkmate/features/news/data/models/article_model.dart';
import 'package:checkmate/features/news/domain/repository/article_repo.dart';
import 'package:dio/dio.dart';

class ArticleRepoImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  ArticleRepoImpl(this._newsApiService);
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final articles = await _newsApiService.getNewsArticles();

      return DataSuccess(articles);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
