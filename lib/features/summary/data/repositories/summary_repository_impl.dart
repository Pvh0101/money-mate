import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/summary_data.dart';
import '../../domain/entities/time_range.dart';
import '../../domain/repositories/summary_repository.dart';
import '../datasources/summary_local_datasource.dart';
import '../datasources/summary_remote_datasource.dart';
import '../models/summary_data_model.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final SummaryRemoteDataSource remoteDataSource;
  final SummaryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SummaryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SummaryData>> getSummaryByTimeRange(
    TimeRange timeRange, {
    String? userId,
    DateTime? referenceDate,
  }) async {
    try {
      // Luôn lấy dữ liệu từ local trước
      final localSummary = await localDataSource.getSummaryByTimeRange(
        timeRange,
        userId: userId,
        referenceDate: referenceDate,
      );

      // Đồng bộ dữ liệu từ remote trong nền nếu có kết nối
      _syncFromRemoteInBackground(
        timeRange: timeRange,
        userId: userId,
        referenceDate: referenceDate,
      );

      return Right(localSummary);
    } on CacheException catch (e) {
      // Nếu không có dữ liệu local, thử lấy từ remote
      if (await networkInfo.isConnected) {
        try {
          final remoteSummary = await remoteDataSource.getSummaryByTimeRange(
            timeRange,
            userId: userId,
            referenceDate: referenceDate,
          );

          // Lưu dữ liệu remote vào local
          await localDataSource.cacheSummary(remoteSummary);

          return Right(remoteSummary);
        } on ServerException catch (e) {
          return Left(ServerFailure(e.message));
        }
      }
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SummaryData>> getSummaryByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    try {
      // Luôn lấy dữ liệu từ local trước
      final localSummary = await localDataSource.getSummaryByDateRange(
        startDate,
        endDate,
        userId: userId,
      );

      print(
          'SummaryRepositoryImpl: Local data loaded successfully. Income=${localSummary.totalIncome}, Expense=${localSummary.totalExpense}');

      // Đồng bộ dữ liệu từ remote trong nền nếu có kết nối
      _syncFromRemoteInBackground(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      );

      return Right(localSummary);
    } on CacheException catch (e) {
      print('SummaryRepositoryImpl: Cache Exception: ${e.message}');
      // Nếu không có dữ liệu local, thử lấy từ remote
      if (await networkInfo.isConnected) {
        try {
          final remoteSummary = await remoteDataSource.getSummaryByDateRange(
            startDate,
            endDate,
            userId: userId,
          );

          print(
              'SummaryRepositoryImpl: Remote data loaded successfully. Income=${remoteSummary.totalIncome}, Expense=${remoteSummary.totalExpense}');

          // Lưu dữ liệu remote vào local
          await localDataSource.cacheSummary(remoteSummary);

          return Right(remoteSummary);
        } on ServerException catch (e) {
          print('SummaryRepositoryImpl: Server Exception: ${e.message}');
          // Nếu cả local và remote đều lỗi, trả về summary rỗng thay vì failure
          return Right(SummaryData.empty());
        }
      }

      print(
          'SummaryRepositoryImpl: No network connection, returning empty summary');
      // Trả về summary rỗng thay vì failure khi không thể kết nối
      return Right(SummaryData.empty());
    } catch (e) {
      print('SummaryRepositoryImpl: Unexpected error: $e');
      // Trả về summary rỗng trong trường hợp xảy ra lỗi không xác định
      return Right(SummaryData.empty());
    }
  }

  // Phương thức đồng bộ dữ liệu từ remote trong nền
  Future<void> _syncFromRemoteInBackground({
    TimeRange? timeRange,
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    DateTime? referenceDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        SummaryDataModel remoteSummary;

        if (timeRange != null) {
          remoteSummary = await remoteDataSource.getSummaryByTimeRange(
            timeRange,
            userId: userId,
            referenceDate: referenceDate,
          );
        } else if (startDate != null && endDate != null) {
          remoteSummary = await remoteDataSource.getSummaryByDateRange(
            startDate,
            endDate,
            userId: userId,
          );
        } else {
          return;
        }

        // Lưu dữ liệu remote vào local
        await localDataSource.cacheSummary(remoteSummary);
      } catch (_) {
        // Bỏ qua lỗi đồng bộ trong nền
      }
    }
  }

  @override
  Future<Either<Failure, bool>> clearSummaryCache() async {
    try {
      await localDataSource.clearSummaries();
      print('SummaryRepositoryImpl: Successfully cleared summary cache');
      return const Right(true);
    } catch (e) {
      print('SummaryRepositoryImpl: Error clearing summary cache: $e');
      return Right(false); // Luôn trả về thành công, không phát sinh lỗi
    }
  }
}
