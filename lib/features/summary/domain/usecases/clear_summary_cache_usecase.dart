import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/summary_repository.dart';

class ClearSummaryCacheUseCase implements UseCase<bool, NoParams> {
  final SummaryRepository repository;

  ClearSummaryCacheUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.clearSummaryCache();
  }
}
