abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Lỗi server']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Lỗi cache']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Lỗi kết nối']) : super(message);
}
