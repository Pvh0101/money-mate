import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/enums/transaction_type.dart';
import '../repositories/transaction_repository.dart';

class GetTotalByTypeUseCase implements UseCase<double, TotalByTypeParams> {
  final TransactionRepository repository;

  GetTotalByTypeUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(TotalByTypeParams params) {
    return repository.getTotalByType(
      params.type,
      userId: params.userId,
      start: params.start,
      end: params.end,
    );
  }
}

class TotalByTypeParams extends Equatable {
  final TransactionType type;
  final String? userId;
  final DateTime? start;
  final DateTime? end;

  const TotalByTypeParams({
    required this.type,
    this.userId,
    this.start,
    this.end,
  });

  @override
  List<Object?> get props => [type, userId, start, end];
}
