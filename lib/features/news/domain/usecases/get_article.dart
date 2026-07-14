import 'package:checkmate/core/resources/data_state.dart';
import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/news/domain/entities/article.dart';
import 'package:checkmate/features/news/domain/repository/article_repo.dart';

class GetArticleUseCase implements UseCase<DataState<List<NewsArticleEntity>>, void> {
  final ArticleRepository _articleRepository;
  GetArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<NewsArticleEntity>>> call({void params}) async {
    return _articleRepository.getNewsArticles();
  }
}
