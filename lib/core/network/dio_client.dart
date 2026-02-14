import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Creates and configures a Dio HTTP client instance
///
/// Includes:
/// - Connection, receive, and send timeouts (30 seconds)
/// - Pretty logging interceptor for debugging
/// - Error handling
Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add pretty logger for debugging (disable in production if needed)
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      // requestBody, responseBody, responseHeader default to false
      // compact defaults to true
      // maxWidth defaults to 90
    ),
  );

  return dio;
}
