import 'package:fliplearnai/features/settings/presentation/stores/ai_config_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings page for configuring AI API keys
///
/// Allows users to select an AI provider (Claude or OpenAI)
/// and securely store their API keys.
class APISettingsPage extends StatefulWidget {
  /// Constructor
  const APISettingsPage({super.key});

  @override
  State<APISettingsPage> createState() => _APISettingsPageState();
}

class _APISettingsPageState extends State<APISettingsPage> {
  late final AIConfigStore _store;
  final _apiKeyController = TextEditingController();
  bool _showConfirmation = false;

  @override
  void initState() {
    super.initState();
    _store = GetIt.instance<AIConfigStore>();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    final success =
        await _store.saveApiKey(_apiKeyController.text.trim());

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API key salva com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      _apiKeyController.clear();
      setState(() => _showConfirmation = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _store.validationError ?? 'Erro ao salvar API key',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _removeApiKey() async {
    await _store.removeApiKey();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('API key removida'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() => _showConfirmation = false);
  }

  Future<void> _launchApiKeyUrl() async {
    final url = _store.selectedProvider == AIProvider.claude
        ? 'https://console.anthropic.com/settings/keys'
        : 'https://platform.openai.com/api-keys';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir URL: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar API'),
        elevation: 0,
      ),
      body: Observer(
        builder: (_) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider selection
                _buildProviderSection(),

                const SizedBox(height: 24),

                // API key input
                if (!_showConfirmation) ...[
                  _buildApiKeyInputSection(),
                  const SizedBox(height: 24),
                ],

                // Action buttons
                if (_store.isConfigured) ...[
                  _buildConfiguredSection(),
                ] else ...[
                  if (!_showConfirmation)
                    _buildCostInfoCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Provider selection section
  Widget _buildProviderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Provedor de IA',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
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
          selected: {_store.selectedProvider},
          onSelectionChanged: (selected) {
            _store.updateProvider(selected.first);
          },
        ),
      ],
    );
  }

  /// API key input section
  Widget _buildApiKeyInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Key',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _apiKeyController,
          obscureText: _store.obscureApiKey,
          decoration: InputDecoration(
            labelText: 'API Key',
            hintText: _store.selectedProvider == AIProvider.claude
                ? 'sk-ant-...'
                : 'sk-...',
            errorText: _store.validationError,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
        TextButton.icon(
          onPressed: _launchApiKeyUrl,
          icon: const Icon(Icons.open_in_new, size: 16),
          label: Text(
            _store.selectedProvider == AIProvider.claude
                ? 'Obter API key da Anthropic'
                : 'Obter API key da OpenAI',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _apiKeyController.text.isNotEmpty &&
                    !_store.isValidating
                ? _saveApiKey
                : null,
            child: _store.isValidating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Salvar API Key'),
          ),
        ),
      ],
    );
  }

  /// Configured state section
  Widget _buildConfiguredSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Key Configurada',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Você pode agora gerar flashcards com IA',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: _removeApiKey,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Remover API Key'),
          ),
        ),
      ],
    );
  }

  /// Cost information card
  Widget _buildCostInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                'Sobre Custos',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Cada flashcard gerado custa aproximadamente:\n'
            r'• Claude Haiku: ~$0.003 (~R$0.015)' '\n'
            r'• GPT-3.5: ~$0.002 (~R$0.01)' '\n\n'
            r'100 flashcards = ~R$1.00',
          ),
        ],
      ),
    );
  }
}
