import 'package:checkmate/features/news/domain/entities/article.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class ArticleState extends Equatable {
  final List<NewsArticleEntity>? articles;
  final DioException? error;

  const ArticleState({this.articles, this.error});
  @override
  List<Object?> get props => [articles, error];
}

class ArticleError extends ArticleState {
  
  const ArticleError(DioException error) : super(error: error);
  
}

class ArticleLoaded extends ArticleState {
  const ArticleLoaded(List<NewsArticleEntity> articles)
    : super(articles: articles);
}

class ArticleLoading extends ArticleState {
  const ArticleLoading();
}
