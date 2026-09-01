import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/bookings/domain/entities/get_lab_search_req_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';

class SearchTestsUseCase
    implements UseCase<List<TestEntity>, GetSearchResultRequestEntity> {
  final LabsRepository labsRepository;
  SearchTestsUseCase(this.labsRepository);
  @override
  Future<List<TestEntity>> call({GetSearchResultRequestEntity? params}) async {
    return await labsRepository.getSearchByQuery(params!);
  }
}
