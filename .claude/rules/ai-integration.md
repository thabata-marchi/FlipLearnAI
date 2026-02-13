# AI Integration Rules

Regras e padrões para integração com APIs de IA (Claude/OpenAI) no FlipLearnAI.

## Visão Geral

O FlipLearnAI é um app de aprendizado de idiomas com **API key opcional**:

### ✅ **Sem API Key** (Obrigatório Suportar)
- Usuários podem criar flashcards **manualmente**
- App inclui 30-50 flashcards pré-carregados para exploração
- Todas as funcionalidades básicas funcionam (criar, editar, deletar, favoritar, buscar, flip)
- **API key é completamente opcional**

### 🚀 **Com API Key** (BYOK - Bring Your Own Key)
- Usuários podem **gerar flashcards usando IA**
- Suporta Claude (Anthropic) e OpenAI
- Reduz significativamente o tempo de criação
- Custo é do usuário (baseado no uso da sua API key)

### 📋 **Regra de Negócio Principal**
```
App Funciona = Sem API Key (manual) OU Com API Key (manual + AI)
App NÃO Funciona = Apenas com API Key
```

O usuário **nunca é bloqueado** de usar o app por não ter uma API key.

## Fluxo de Uso - Dois Modos

### Modo 1: Sem API Key (Default)
```
┌─────────────┐
│   Usuário   │
└──────┬──────┘
       │
       ├─ Vê 30-50 flashcards pré-carregados
       │
       ├─ Clica FAB → Abre CreateFlashcardPage
       │             Tab "Manual" ativa
       │             Tab "AI" desativado (mostra prompt de configurar)
       │
       └─ Cria flashcards manualmente
          ├ Preenche form (front, back, exemplo, pronúncia)
          └ Salva localmente via FlashcardStore.createFlashcard()
```

### Modo 2: Com API Key (Opcional)
```
┌─────────────────┐
│   Usuário       │
└────────┬────────┘
         │
         ├─ Tap Settings → APISettingsPage
         │  ├ Seleciona provider (Claude/OpenAI)
         │  ├ Insere API key (valida formato: sk-ant-... ou sk-...)
         │  └ Salva em SecureStorageService
         │
         └─ Agora pode:
            ├ Criar manual (Tab "Manual" - sempre funciona)
            └ Gerar com IA (Tab "AI" - agora disponível)
               ├ Insere palavra
               ├ Clica Generate
               ├ FlashcardStore checa isConfigured
               ├ Se OK, chama GenerateFlashcardWithAI usecase
               ├ Usecase chama repository.generateWithAI()
               ├ Repository chama AIRemoteDataSource
               ├ Claude/OpenAI gera flashcard completo
               └ Salva localmente
```

## Arquitetura de Integração

```
┌──────────────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                           │
│  ┌─────────────────────┐      ┌──────────────────────┐      │
│  │ AIConfigStore       │      │ FlashcardStore       │      │
│  │ (isConfigured,      │      │ (canUseAI,           │      │
│  │  provider, key mgmt)│      │  generateWithAI)     │      │
│  └─────────────┬───────┘      └──────────────┬───────┘      │
│                │ checks status              │ checks status  │
│                └─────────────────┬──────────┘              │
│                    (via store)   │                          │
└──────────────────────────────────┼─────────────────────────┘
                                   │
                ┌──────────────────▼──────────────────┐
                │    DOMAIN LAYER (No changes needed) │
                │  ┌────────────────────────────────┐│
                │  │ CreateFlashcard (UseCase)      ││ Always works
                │  │ GenerateFlashcardWithAI        ││ Needs API key
                │  └────────────────────────────────┘│
                └──────────────────┬─────────────────┘
                                   │
                ┌──────────────────▼──────────────────┐
                │      DATA LAYER (Unchanged)         │
                │  ┌────────────────────────────────┐│
                │  │ FlashcardLocalDataSource       ││ Local storage
                │  │ AIRemoteDataSource (Factory)   ││ Claude/OpenAI
                │  │ SecureStorageService           ││ API keys (secure)
                │  └────────────────────────────────┘│
                └─────────────────────────────────────┘
```

**Key Point:** Separation between optional AI features and core functionality

## Padrão: API Key Opcional

### Verificando se API Key está Configurada

```dart
// No Store (FlashcardStore)
@computed
bool get canUseAI => aiConfigStore.isConfigured;

// Na UI, sempre verificar antes de tentar usar AI
if (flashcardStore.canUseAI) {
  // Mostrar tab/botão de IA
} else {
  // Mostrar prompt "Configure API Key"
}
```

### Criação Manual (Sempre Funciona)

```dart
// No FlashcardStore - NUNCA verifica API key
@action
Future<void> createFlashcard(Flashcard flashcard) async {
  final result = await createFlashcardUseCase(
    CreateFlashcardParams(flashcard: flashcard),
  );
  // ... handle result
}
```

### Geração com IA (Requer API Key)

```dart
// No FlashcardStore - verifica API key ANTES de tentar
@action
Future<void> generateFlashcardWithAI({
  required String word,
  required String aiProvider,
}) async {
  // Verificar se API key está configurada
  if (!canUseAI) {
    errorMessage = 'Nenhuma API key configurada. Configure nas Configurações.';
    return;
  }

  // Obter API key do storage
  final apiKey = await _storageService.getApiKey();
  if (apiKey == null) {
    errorMessage = 'Erro ao recuperar API key';
    return;
  }

  isGeneratingWithAI = true;
  errorMessage = null;

  final result = await generateWithAIUseCase(
    GenerateFlashcardWithAIParams(
      word: word,
      aiProvider: aiProvider,
      apiKey: apiKey, // Passa explicitamente
    ),
  );

  result.fold(
    (failure) => errorMessage = failure.message,
    (generated) => flashcards.add(generated),
  );

  isGeneratingWithAI = false;
}
```

## Configuração da API Key (BYOK)

### Armazenamento Seguro

```dart
// lib/core/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<void> saveApiKey(String key);
  Future<String?> getApiKey();
  Future<void> deleteApiKey();
  Future<bool> hasApiKey();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;
  
  static const _apiKeyKey = 'ai_api_key';
  static const _providerKey = 'ai_provider';

  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  @override
  Future<void> saveApiKey(String key) async {
    await _storage.write(key: _apiKeyKey, value: key);
  }

  @override
  Future<String?> getApiKey() async {
    return await _storage.read(key: _apiKeyKey);
  }

  @override
  Future<void> deleteApiKey() async {
    await _storage.delete(key: _apiKeyKey);
  }

  @override
  Future<bool> hasApiKey() async {
    final key = await getApiKey();
    return key != null && key.isNotEmpty;
  }

  Future<void> saveProvider(AIProvider provider) async {
    await _storage.write(key: _providerKey, value: provider.name);
  }

  Future<AIProvider> getProvider() async {
    final value = await _storage.read(key: _providerKey);
    return AIProvider.values.firstWhere(
      (p) => p.name == value,
      orElse: () => AIProvider.claude,
    );
  }
}
```

### AI Config Store

```dart
// lib/features/settings/presentation/stores/ai_config_store.dart
part 'ai_config_store.g.dart';

enum AIProvider { claude, openai }

class AIConfigStore = _AIConfigStoreBase with _$AIConfigStore;

abstract class _AIConfigStoreBase with Store {
  final SecureStorageService _storageService;

  _AIConfigStoreBase({
    required SecureStorageService storageService,
  }) : _storageService = storageService;

  @observable
  bool isConfigured = false;

  @observable
  String selectedProvider = 'claude'; // 'claude' or 'openai'

  @observable
  String? validationError; // Format validation only

  @observable
  bool obscureApiKey = true;

  @action
  Future<void> initialize() async {
    isConfigured = await _storageService.hasApiKey();
    // Load provider if exists (default to claude)
  }

  @action
  Future<bool> saveApiKey(String apiKey) async {
    validationError = null;

    // VALIDATION: Format only (no API call)
    if (!_isValidKeyFormat(apiKey)) {
      validationError = _getFormatErrorMessage();
      return false;
    }

    // Save to secure storage
    try {
      await _storageService.saveApiKey(apiKey);
      isConfigured = true;
      return true;
    } catch (e) {
      validationError = 'Erro ao salvar API key: $e';
      return false;
    }
  }

  @action
  Future<void> removeApiKey() async {
    await _storageService.deleteApiKey();
    isConfigured = false;
    validationError = null;
  }

  @action
  void setProvider(String newProvider) {
    selectedProvider = newProvider;
  }

  @action
  void toggleObscureApiKey() {
    obscureApiKey = !obscureApiKey;
  }

  /// Validates API key format ONLY (no API calls for cost savings)
  bool _isValidKeyFormat(String key) {
    if (key.isEmpty) return false;

    if (selectedProvider == 'claude') {
      // Claude keys must start with "sk-ant-" and be reasonably long
      return key.startsWith('sk-ant-') && key.length > 20;
    } else {
      // OpenAI keys must start with "sk-" and be reasonably long
      return key.startsWith('sk-') && key.length > 20;
    }
  }

  String _getFormatErrorMessage() {
    if (selectedProvider == 'claude') {
      return 'Chave Claude deve começar com "sk-ant-" e ter no mínimo 20 caracteres';
    } else {
      return 'Chave OpenAI deve começar com "sk-" e ter no mínimo 20 caracteres';
    }
  }
}
```

## Data Sources

### Interface Abstrata

```dart
// lib/features/flashcard/data/datasources/ai_remote_datasource.dart
abstract class AIRemoteDataSource {
  /// Gera um flashcard completo usando IA
  /// 
  /// [word] - Palavra em português ou inglês
  /// [sourceLanguage] - Idioma da palavra ('pt' ou 'en')
  /// 
  /// Throws [AIServiceException] se a API retornar erro
  /// Throws [NetworkException] se houver problema de conexão
  Future<FlashcardModel> generateFlashcard({
    required String word,
    required String sourceLanguage,
  });

  /// Valida se a API key está funcionando
  Future<bool> validateApiKey();
}
```

### Implementação Claude (Anthropic)

```dart
// lib/features/flashcard/data/datasources/claude_datasource_impl.dart
class ClaudeDataSourceImpl implements AIRemoteDataSource {
  final Dio _dio;
  final SecureStorageService _storageService;

  static const _baseUrl = 'https://api.anthropic.com/v1';
  static const _model = 'claude-3-haiku-20240307'; // Mais barato
  static const _maxTokens = 500;

  ClaudeDataSourceImpl({
    required Dio dio,
    required SecureStorageService storageService,
  })  : _dio = dio,
        _storageService = storageService;

  @override
  Future<FlashcardModel> generateFlashcard({
    required String word,
    required String sourceLanguage,
  }) async {
    final apiKey = await _storageService.getApiKey();
    
    if (apiKey == null) {
      throw AIServiceException('API key não configurada');
    }

    final prompt = _buildPrompt(word, sourceLanguage);

    try {
      final response = await _dio.post(
        '$_baseUrl/messages',
        options: Options(
          headers: {
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
        ),
        data: {
          'model': _model,
          'max_tokens': _maxTokens,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        },
      );

      return _parseResponse(response.data, word);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<bool> validateApiKey() async {
    final apiKey = await _storageService.getApiKey();
    
    if (apiKey == null) return false;

    try {
      // Chamada mínima para validar a key
      await _dio.post(
        '$_baseUrl/messages',
        options: Options(
          headers: {
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
        ),
        data: {
          'model': _model,
          'max_tokens': 10,
          'messages': [
            {'role': 'user', 'content': 'Hi'},
          ],
        },
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return false;
      }
      rethrow;
    }
  }

  String _buildPrompt(String word, String sourceLanguage) {
    final targetLanguage = sourceLanguage == 'pt' ? 'inglês' : 'português';
    final sourceLangName = sourceLanguage == 'pt' ? 'português' : 'inglês';

    return '''
Você é um assistente de aprendizado de idiomas. Gere um flashcard para a palavra "$word" em $sourceLangName.

Responda APENAS em JSON válido, sem markdown, sem explicações:

{
  "front": "palavra original",
  "back": "tradução para $targetLanguage",
  "example_original": "frase de exemplo no idioma original",
  "example_translated": "tradução da frase de exemplo",
  "pronunciation_tip": "dica de pronúncia (opcional)",
  "usage_context": "contexto de uso (formal/informal/etc)"
}
''';
  }

  FlashcardModel _parseResponse(Map<String, dynamic> response, String word) {
    try {
      final content = response['content'][0]['text'] as String;
      final jsonData = jsonDecode(content) as Map<String, dynamic>;

      return FlashcardModel(
        id: const Uuid().v4(),
        front: jsonData['front'] as String,
        back: jsonData['back'] as String,
        example: jsonData['example_original'] as String?,
        exampleTranslation: jsonData['example_translated'] as String?,
        pronunciationTip: jsonData['pronunciation_tip'] as String?,
        usageContext: jsonData['usage_context'] as String?,
        createdAt: DateTime.now(),
        source: FlashcardSource.ai,
      );
    } catch (e) {
      throw AIServiceException(
        'Erro ao processar resposta da IA',
        originalError: e,
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
          'Limite de requisições excedido. Tente novamente em alguns minutos.',
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
            e.type == DioExceptionType.receiveTimeout) {
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
```

### Implementação OpenAI

```dart
// lib/features/flashcard/data/datasources/openai_datasource_impl.dart
class OpenAIDataSourceImpl implements AIRemoteDataSource {
  final Dio _dio;
  final SecureStorageService _storageService;

  static const _baseUrl = 'https://api.openai.com/v1';
  static const _model = 'gpt-3.5-turbo'; // Mais barato
  static const _maxTokens = 500;

  OpenAIDataSourceImpl({
    required Dio dio,
    required SecureStorageService storageService,
  })  : _dio = dio,
        _storageService = storageService;

  @override
  Future<FlashcardModel> generateFlashcard({
    required String word,
    required String sourceLanguage,
  }) async {
    final apiKey = await _storageService.getApiKey();
    
    if (apiKey == null) {
      throw AIServiceException('API key não configurada');
    }

    final prompt = _buildPrompt(word, sourceLanguage);

    try {
      final response = await _dio.post(
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

      return _parseResponse(response.data, word);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<bool> validateApiKey() async {
    final apiKey = await _storageService.getApiKey();
    
    if (apiKey == null) return false;

    try {
      await _dio.get(
        '$_baseUrl/models',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        ),
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return false;
      }
      rethrow;
    }
  }

  String _buildPrompt(String word, String sourceLanguage) {
    // Similar ao Claude
    // ...
  }

  FlashcardModel _parseResponse(Map<String, dynamic> response, String word) {
    try {
      final content = response['choices'][0]['message']['content'] as String;
      final jsonData = jsonDecode(content) as Map<String, dynamic>;
      
      // Similar ao Claude
      // ...
    } catch (e) {
      throw AIServiceException(
        'Erro ao processar resposta da IA',
        originalError: e,
      );
    }
  }

  Exception _handleDioError(DioException e) {
    // Similar ao Claude com códigos específicos da OpenAI
    // ...
  }
}
```

## Factory Pattern para DataSource

```dart
// lib/features/flashcard/data/datasources/ai_datasource_factory.dart
class AIDataSourceFactory {
  final ClaudeDataSourceImpl _claudeDataSource;
  final OpenAIDataSourceImpl _openAIDataSource;
  final SecureStorageService _storageService;

  AIDataSourceFactory({
    required ClaudeDataSourceImpl claudeDataSource,
    required OpenAIDataSourceImpl openAIDataSource,
    required SecureStorageService storageService,
  })  : _claudeDataSource = claudeDataSource,
        _openAIDataSource = openAIDataSource,
        _storageService = storageService;

  Future<AIRemoteDataSource> getDataSource() async {
    final provider = await _storageService.getProvider();
    
    switch (provider) {
      case AIProvider.claude:
        return _claudeDataSource;
      case AIProvider.openai:
        return _openAIDataSource;
    }
  }
}
```

## Use Case

```dart
// lib/features/flashcard/domain/usecases/generate_flashcard_with_ai.dart
class GenerateFlashcardWithAI 
    extends UseCase<Flashcard, GenerateFlashcardParams> {
  final FlashcardRepository _repository;

  GenerateFlashcardWithAI(this._repository);

  @override
  Future<Either<Failure, Flashcard>> call(GenerateFlashcardParams params) {
    return _repository.generateWithAI(
      word: params.word,
      sourceLanguage: params.sourceLanguage,
    );
  }
}

class GenerateFlashcardParams extends Equatable {
  final String word;
  final String sourceLanguage;

  const GenerateFlashcardParams({
    required this.word,
    this.sourceLanguage = 'pt',
  });

  @override
  List<Object?> get props => [word, sourceLanguage];
}
```

## Tratamento de Erros

### Exceções Customizadas

```dart
// lib/core/errors/exceptions.dart
class AIServiceException implements Exception {
  final String message;
  final String? code;
  final Object? originalError;

  AIServiceException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AIServiceException: $message (code: $code)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
```

### Failures

```dart
// lib/core/errors/failures.dart
class AIServiceFailure extends Failure {
  final String? code;
  final bool isRetryable;

  AIServiceFailure(
    String message, {
    this.code,
    this.isRetryable = false,
  }) : super(message);

  factory AIServiceFailure.fromException(AIServiceException e) {
    final isRetryable = e.code == 'RATE_LIMIT' || 
                        e.code == 'SERVICE_UNAVAILABLE';
    return AIServiceFailure(
      e.message,
      code: e.code,
      isRetryable: isRetryable,
    );
  }
}

class APIKeyNotConfiguredFailure extends Failure {
  APIKeyNotConfiguredFailure() : super('API key não configurada');
}
```

## UI de Configuração

### Tela de Configuração da API

```dart
// lib/features/settings/presentation/pages/api_settings_page.dart
class APISettingsPage extends StatefulWidget {
  const APISettingsPage({super.key});

  @override
  State<APISettingsPage> createState() => _APISettingsPageState();
}

class _APISettingsPageState extends State<APISettingsPage> {
  final _apiKeyController = TextEditingController();
  late AIConfigStore _store;

  @override
  void initState() {
    super.initState();
    _store = Provider.of<AIConfigStore>(context, listen: false);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    final success = await _store.saveApiKey(_apiKeyController.text.trim());
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key salva com sucesso!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar API')),
      body: Observer(
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seleção do Provider
              const Text('Provedor de IA'),
              const SizedBox(height: 8),
              SegmentedButton<AIProvider>(
                segments: const [
                  ButtonSegment(
                    value: AIProvider.claude,
                    label: Text('Claude'),
                    icon: Icon(Icons.auto_awesome),
                  ),
                  ButtonSegment(
                    value: AIProvider.openai,
                    label: Text('OpenAI'),
                    icon: Icon(Icons.psychology),
                  ),
                ],
                selected: {_store.provider},
                onSelectionChanged: (selected) {
                  _store.setProvider(selected.first);
                },
              ),
              
              const SizedBox(height: 24),
              
              // Input da API Key
              TextField(
                controller: _apiKeyController,
                obscureText: _store.obscureApiKey,
                decoration: InputDecoration(
                  labelText: 'API Key',
                  hintText: _store.provider == AIProvider.claude
                      ? 'sk-ant-...'
                      : 'sk-...',
                  errorText: _store.validationError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _store.obscureApiKey
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _store.toggleObscureApiKey,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Link para obter API key
              TextButton.icon(
                onPressed: () => _launchApiKeyUrl(),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(
                  _store.provider == AIProvider.claude
                      ? 'Obter API key da Anthropic'
                      : 'Obter API key da OpenAI',
                ),
              ),
              
              const Spacer(),
              
              // Botão Salvar
              AppButton(
                label: 'Salvar API Key',
                isLoading: _store.isValidating,
                onPressed: _apiKeyController.text.isNotEmpty
                    ? _saveApiKey
                    : null,
              ),
              
              const SizedBox(height: 16),
              
              // Info sobre custos
              const _CostInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  void _launchApiKeyUrl() {
    final url = _store.provider == AIProvider.claude
        ? 'https://console.anthropic.com/settings/keys'
        : 'https://platform.openai.com/api-keys';
    launchUrl(Uri.parse(url));
  }
}

class _CostInfoCard extends StatelessWidget {
  const _CostInfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Text(
                  'Sobre custos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Cada flashcard gerado custa aproximadamente:\n'
              '• Claude Haiku: ~\$0.003 (~R\$0.015)\n'
              '• GPT-3.5: ~\$0.002 (~R\$0.01)\n\n'
              '100 flashcards = ~R\$1.00',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Retry Pattern

```dart
// lib/core/utils/retry_helper.dart
class RetryHelper {
  static Future<T> withRetry<T>({
    required Future<T> Function() action,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    bool Function(Exception)? shouldRetry,
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        attempts++;
        return await action();
      } on Exception catch (e) {
        if (attempts >= maxAttempts) rethrow;
        
        final canRetry = shouldRetry?.call(e) ?? _defaultShouldRetry(e);
        if (!canRetry) rethrow;

        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      }
    }
  }

  static bool _defaultShouldRetry(Exception e) {
    if (e is AIServiceException) {
      return e.code == 'RATE_LIMIT' || e.code == 'SERVICE_UNAVAILABLE';
    }
    if (e is NetworkException) {
      return true;
    }
    return false;
  }
}

// Uso no repository
Future<Either<Failure, Flashcard>> generateWithAI({
  required String word,
  required String sourceLanguage,
}) async {
  try {
    final dataSource = await _aiDataSourceFactory.getDataSource();
    
    final model = await RetryHelper.withRetry(
      action: () => dataSource.generateFlashcard(
        word: word,
        sourceLanguage: sourceLanguage,
      ),
      maxAttempts: 3,
    );

    // Salvar localmente após gerar
    await _localDataSource.saveFlashcard(model);
    
    return Right(model.toEntity());
  } on AIServiceException catch (e) {
    return Left(AIServiceFailure.fromException(e));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  }
}
```

## Testes

### Mock do DataSource

```dart
// test/mocks/mock_ai_datasource.dart
class MockAIRemoteDataSource extends Mock implements AIRemoteDataSource {}

// test/unit/data/datasources/claude_datasource_test.dart
void main() {
  late ClaudeDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockSecureStorageService();
    dataSource = ClaudeDataSourceImpl(
      dio: mockDio,
      storageService: mockStorage,
    );
  });

  group('generateFlashcard', () {
    test('should return FlashcardModel when API call succeeds', () async {
      // Arrange
      when(mockStorage.getApiKey()).thenAnswer((_) async => 'sk-ant-test');
      when(mockDio.post(
        any,
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
        data: {
          'content': [
            {
              'text': '{"front":"hello","back":"olá","example_original":"Hello world"}'
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      // Act
      final result = await dataSource.generateFlashcard(
        word: 'hello',
        sourceLanguage: 'en',
      );

      // Assert
      expect(result.front, 'hello');
      expect(result.back, 'olá');
    });

    test('should throw AIServiceException when API key is invalid', () async {
      // Arrange
      when(mockStorage.getApiKey()).thenAnswer((_) async => 'invalid');
      when(mockDio.post(
        any,
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(DioException(
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        ),
        requestOptions: RequestOptions(path: ''),
      ));

      // Act & Assert
      expect(
        () => dataSource.generateFlashcard(word: 'test', sourceLanguage: 'pt'),
        throwsA(isA<AIServiceException>()),
      );
    });
  });
}
```

## Decisões de Design

### Por que apenas Validação de Formato?
- **Evita custo**: Chamada de validação custa ~$0.001
- **Mais rápido**: Validação instantânea vs latência de rede
- **UX melhor**: Feedback imediato ao usuário
- **Fallback gracioso**: Se a key estiver inválida, erro ocorre na primeira tentativa de gerar

### Por que 30-50 Flashcards Pré-carregados?
- App funciona mesmo sem API key
- Usuário pode explorar todas as funcionalidades antes de configurar
- Reduz barreira de entrada
- Seed data é carregado apenas na primeira execução

### Por que API Key no TabView, não em Modal?
- Melhor UX: trocar entre manual e AI é fluido
- Mantém contexto: usuário vê ambas opções lado a lado
- Menos clicks: não precisa de confirmação para entrar na página

## Checklist de Segurança

- [ ] **NUNCA** armazenar API key em plain text
- [ ] **NUNCA** commitar API keys no código
- [ ] **NUNCA** logar API keys (nem parcialmente)
- [ ] Usar `flutter_secure_storage` para armazenamento
- [ ] Validar **formato** da key antes de salvar (sem chamada API)
- [ ] Permitir que usuário remova a key facilmente
- [ ] Mostrar informação de custos para o usuário
- [ ] Tratar todos os erros de API graciosamente
- [ ] App deve funcionar **sem API key** (nunca bloquear por isso)

## Dependências Necessárias

```yaml
# pubspec.yaml
dependencies:
  dio: ^5.x
  flutter_secure_storage: ^9.x
  uuid: ^4.x

dev_dependencies:
  mockito: ^5.x
```

## Referências

- Anthropic API Docs: https://docs.anthropic.com/
- OpenAI API Docs: https://platform.openai.com/docs/
- Flutter Secure Storage: https://pub.dev/packages/flutter_secure_storage