import 'package:checkmate/features/news/data/data_sources/remote/news_api_service.dart';
import 'package:checkmate/features/news/data/repository/article_repo_impl.dart';
import 'package:checkmate/features/news/domain/repository/article_repo.dart';
import 'package:checkmate/features/news/domain/usecases/get_article.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  s1.registerSingleton<Dio>(Dio());

  // Dependencies
  s1.registerSingleton<NewsApiService>(NewsApiService(s1()));

  s1.registerSingleton<ArticleRepository>(ArticleRepoImpl(s1()));

  // use cases
  s1.registerSingleton<GetArticleUseCase>(GetArticleUseCase(s1()));

  // Blocs
  s1.registerFactory<ArticleBloc>(() => ArticleBloc(s1()));
}
