// lib/core/error/exceptions.dart

class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class CacheException implements Exception {}

class NetworkException implements Exception {}
