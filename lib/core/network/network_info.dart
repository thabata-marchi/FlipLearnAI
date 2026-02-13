import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Abstract service for checking internet connectivity
abstract class NetworkInfo {
  /// Check if device has active internet connection
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo using internet_connection_checker_plus
class NetworkInfoImpl implements NetworkInfo {
  /// Constructor
  ///
  /// Accepts optional custom connection checker for testing.
  /// Defaults to [InternetConnection()] if not provided.
  NetworkInfoImpl({InternetConnection? connectionChecker})
      : _connectionChecker = connectionChecker ??
            InternetConnection();

  final InternetConnection _connectionChecker;

  @override
  Future<bool> get isConnected => _connectionChecker.hasInternetAccess;
}
