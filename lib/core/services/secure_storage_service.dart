import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstract service for securely storing API credentials
abstract class SecureStorageService {
  /// Save API key securely
  ///
  /// Throws [Exception] if operation fails
  Future<void> saveApiKey(String key);

  /// Retrieve saved API key
  ///
  /// Returns null if key hasn't been saved
  Future<String?> getApiKey();

  /// Delete saved API key
  ///
  /// Throws [Exception] if operation fails
  Future<void> deleteApiKey();

  /// Check if API key has been configured
  Future<bool> hasApiKey();

  /// Save AI provider preference (claude or openai)
  ///
  /// Throws [Exception] if operation fails
  Future<void> saveProvider(String provider);

  /// Get saved AI provider preference
  ///
  /// Returns null if provider hasn't been saved
  Future<String?> getProvider();
}

/// Implementation of SecureStorageService using flutter_secure_storage
///
/// Uses platform-specific secure storage:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences
class SecureStorageServiceImpl implements SecureStorageService {
  /// Creates a new instance of [SecureStorageServiceImpl]
  ///
  /// Optionally accepts a custom [storage] instance for testing
  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  static const _apiKeyKey = 'ai_api_key';
  static const _providerKey = 'ai_provider';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveApiKey(String key) async {
    try {
      await _storage.write(key: _apiKeyKey, value: key);
    } catch (e) {
      throw Exception('Failed to save API key: $e');
    }
  }

  @override
  Future<String?> getApiKey() async {
    try {
      return await _storage.read(key: _apiKeyKey);
    } catch (e) {
      throw Exception('Failed to retrieve API key: $e');
    }
  }

  @override
  Future<void> deleteApiKey() async {
    try {
      await _storage.delete(key: _apiKeyKey);
    } catch (e) {
      throw Exception('Failed to delete API key: $e');
    }
  }

  @override
  Future<bool> hasApiKey() async {
    try {
      final key = await getApiKey();
      return key != null && key.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveProvider(String provider) async {
    try {
      await _storage.write(key: _providerKey, value: provider);
    } catch (e) {
      throw Exception('Failed to save provider: $e');
    }
  }

  @override
  Future<String?> getProvider() async {
    try {
      return await _storage.read(key: _providerKey);
    } catch (e) {
      throw Exception('Failed to retrieve provider: $e');
    }
  }
}
