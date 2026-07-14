import 'package:checkmate/features/auth/data/data_sources/auth_datasource.dart';
import 'package:checkmate/features/auth/data/repository/auth_impl.dart';
import 'package:checkmate/features/auth/domain/repository/auth_repository.dart';
import 'package:checkmate/features/auth/domain/usecases/add_otp_to_db.dart';
import 'package:checkmate/features/auth/domain/usecases/delete_existing_otp_fr_db.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:checkmate/features/news/data/data_sources/remote/news_api_service.dart';
import 'package:checkmate/features/news/data/repository/article_repo_impl.dart';
import 'package:checkmate/features/news/domain/repository/article_repo.dart';
import 'package:checkmate/features/news/domain/usecases/get_article.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  //=====================================================
  // AUTH - STARTS
  //=====================================================

  // Supabase Client
  s1.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // Datasource
  s1.registerLazySingleton<AuthDatasource>(() => AuthDatasource(s1()));

  // Repository
  s1.registerLazySingleton<AuthRepository>(() => AuthRepoImplementation(s1()));

  // Use Cases
  s1.registerLazySingleton(() => AddOtpToDbUseCase(s1()));

  s1.registerLazySingleton(() => DeleteOtpFrDbUseCase(s1()));

  // Bloc
  s1.registerFactory(
    () => OtpBloc(addOtpToDbUseCase: s1(), deleteOtpFrDbUseCase: s1()),
  );

  //=====================================================
  // AUTH - ENDS
  //=====================================================
}
