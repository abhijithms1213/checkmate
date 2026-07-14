import 'package:checkmate/core/resources/data_state.dart';
import 'package:checkmate/features/news/domain/usecases/get_article.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_event.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetArticleUseCase _getArticleUseCase;
  ArticleBloc(this._getArticleUseCase) : super(const ArticleLoading()) {
    on<GetArticles>(onGetArticles);
  }
  void onGetArticles(GetArticles event, Emitter<ArticleState> emit) async {
    final dataState = await _getArticleUseCase();
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(ArticleLoaded(dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(ArticleError(dataState.error!));
    }
  }
}
