class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Lỗi máy chủ']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Lỗi cache']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Lỗi kết nối']);
}
