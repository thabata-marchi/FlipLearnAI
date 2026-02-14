import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fliplearnai/core/errors/exceptions.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/ai_remote_datasource.dart';
import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';
import 'package:uuid/uuid.dart';

/// Implementation of AIRemoteDataSource using OpenAI API
///
/// Generates flashcards using GPT-3.5 Turbo model via the OpenAI API.
/// Uses BYOK (Bring Your Own Key) pattern for secure API key management.
class OpenAIDataSourceImpl implements AIRemoteDataSource {
  static const _baseUrl = 'https://api.openai.com/v1';
  static const _model = 'gpt-3.5-turbo';
  static const _maxTokens = 500;

  final Dio _dio;

  /// Constructor
  OpenAIDataSourceImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<FlashcardModel> generateFlashcard({
    required String word,
    required String aiProvider,
    required String apiKey,
  }) async {
    try {
      final prompt = _buildPrompt(word, aiProvider);

      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': _model,
          'max_tokens': _maxTokens,
          'temperature': 0.7,
          'messages': [
            {
              'role': 'system',
              'content': 'Você é um assistente de aprendizado de idiomas. '
                  'Sempre responda em JSON válido.',
            },
            {'role': 'user', 'content': prompt},
          ],
        },
      );

      if (response.data == null) {
        throw AIServiceException(
          'Empty response from API',
          code: 'EMPTY_RESPONSE',
        );
      }

      return _parseResponse(response.data!, word);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AIServiceException(
        'Unexpected error: $e',
        code: 'UNKNOWN',
      );
    }
  }

  String _buildPrompt(String word, String sourceLanguage) {
    final targetLanguage = sourceLanguage == 'openai' ? 'inglês' : 'português';
    final sourceLangName =
        sourceLanguage == 'openai' ? 'português' : 'inglês';

    return '''
Gere um flashcard para a palavra "$word" em $sourceLangName.

Responda APENAS em JSON válido, sem markdown, sem explicações extras:

{
  "front": "palavra original ou expressão",
  "back": "tradução para $targetLanguage",
  "example_original": "frase de exemplo no idioma original",
  "example_translated": "tradução da frase de exemplo",
  "pronunciation_tip": "dica de pronúncia (opcional)",
  "usage_context": "contexto de uso (formal/informal/etc) (opcional)"
}
''';
  }

  FlashcardModel _parseResponse(Map<String, dynamic> response, String word) {
    try {
      final choices = response['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw AIServiceException(
          'No choices in response',
          code: 'PARSE_ERROR',
        );
      }

      final message = choices[0] as Map<String, dynamic>?;
      if (message == null) {
        throw AIServiceException(
          'Invalid choice format',
          code: 'PARSE_ERROR',
        );
      }

      final content = message['message'] as Map<String, dynamic>?;
      if (content == null) {
        throw AIServiceException(
          'No message in choice',
          code: 'PARSE_ERROR',
        );
      }

      final contentText = content['content'] as String?;
      if (contentText == null) {
        throw AIServiceException(
          'No content in message',
          code: 'PARSE_ERROR',
        );
      }

      final jsonData = jsonDecode(contentText) as Map<String, dynamic>;

      return FlashcardModel(
        id: const Uuid().v4(),
        front: jsonData['front'] as String? ?? word,
        back: jsonData['back'] as String? ?? '',
        example: jsonData['example_original'] as String?,
        pronunciation: jsonData['pronunciation_tip'] as String?,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw AIServiceException(
        'Failed to parse AI response: $e',
        code: 'PARSE_ERROR',
      );
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return AIServiceException(
          'API key inválida ou expirada',
          code: 'INVALID_API_KEY',
        );
      case 429:
        return AIServiceException(
          'Limite de requisições excedido. Tente novamente em alguns '
          'minutos.',
          code: 'RATE_LIMIT',
        );
      case 500:
      case 502:
      case 503:
        return AIServiceException(
          'Serviço da IA temporariamente indisponível',
          code: 'SERVICE_UNAVAILABLE',
        );
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          return NetworkException('Tempo de conexão esgotado');
        }
        if (e.type == DioExceptionType.connectionError) {
          return NetworkException('Sem conexão com a internet');
        }
        return AIServiceException(
          e.message ?? 'Erro desconhecido',
          code: 'UNKNOWN',
        );
    }
  }
}
