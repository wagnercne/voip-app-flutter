import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  AppSettings? _settings;
  bool _isLoading = true;
  bool _isSaving = false;

  // Controllers para STUN/TURN servers
  final List<TextEditingController> _stunControllers = [];
  final List<TextEditingController> _turnControllers = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final settings = await _settingsService.getSettings();
      setState(() {
        _settings = settings;
        _isLoading = false;
      });
      _initializeControllers();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeControllers() {
    if (_settings == null) return;

    // Limpar controllers existentes
    for (var controller in _stunControllers) {
      controller.dispose();
    }
    for (var controller in _turnControllers) {
      controller.dispose();
    }
    _stunControllers.clear();
    _turnControllers.clear();

    // Inicializar STUN controllers
    for (String server in _settings!.stunServers) {
      _stunControllers.add(TextEditingController(text: server));
    }

    // Inicializar TURN controllers
    for (String server in _settings!.turnServers) {
      _turnControllers.add(TextEditingController(text: server));
    }
  }

  @override
  void dispose() {
    for (var controller in _stunControllers) {
      controller.dispose();
    }
    for (var controller in _turnControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (_settings == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Atualizar listas de servidores dos controllers
      final stunServers = _stunControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final turnServers = _turnControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final updatedSettings = _settings!.copyWith(
        stunServers: stunServers,
        turnServers: turnServers,
      );

      await _settingsService.saveSettings(updatedSettings);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configurações salvas com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar configurações: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_settings == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar configurações')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações Avançadas'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: _isSaving 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveSettings,
            tooltip: 'Salvar configurações',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCodecSection(),
            const SizedBox(height: 24),
            _buildQualitySection(),
            const SizedBox(height: 24),
            _buildAudioProcessingSection(),
            const SizedBox(height: 24),
            _buildServersSection(),
            const SizedBox(height: 32),
            _buildResetSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCodecSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Codecs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Audio Codec
            const Text('Codec de Áudio'),
            DropdownButtonFormField<String>(
              value: _settings!.audioCodec,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'OPUS', child: Text('OPUS (Recomendado)')),
                DropdownMenuItem(value: 'G722', child: Text('G.722')),
                DropdownMenuItem(value: 'PCMU', child: Text('PCMU (G.711μ)')),
                DropdownMenuItem(value: 'PCMA', child: Text('PCMA (G.711a)')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _settings = _settings!.copyWith(audioCodec: value);
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Video Codec
            const Text('Codec de Vídeo'),
            DropdownButtonFormField<String>(
              value: _settings!.videoCodec,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'VP8', child: Text('VP8 (Recomendado)')),
                DropdownMenuItem(value: 'VP9', child: Text('VP9')),
                DropdownMenuItem(value: 'H264', child: Text('H.264')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _settings = _settings!.copyWith(videoCodec: value);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Qualidade',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Audio Quality
            Text('Qualidade do Áudio: ${_settings!.audioQuality}%'),
            Slider(
              value: _settings!.audioQuality.toDouble(),
              min: 0,
              max: 100,
              divisions: 10,
              label: '${_settings!.audioQuality}%',
              onChanged: (value) {
                setState(() {
                  _settings = _settings!.copyWith(audioQuality: value.round());
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Video Quality
            Text('Qualidade do Vídeo: ${_settings!.videoQuality}%'),
            Slider(
              value: _settings!.videoQuality.toDouble(),
              min: 0,
              max: 100,
              divisions: 10,
              label: '${_settings!.videoQuality}%',
              onChanged: (value) {
                setState(() {
                  _settings = _settings!.copyWith(videoQuality: value.round());
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioProcessingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Processamento de Áudio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Cancelamento de Eco'),
              subtitle: const Text('Reduz o eco durante chamadas'),
              value: _settings!.enableEchoCancellation,
              onChanged: (value) {
                setState(() {
                  _settings = _settings!.copyWith(enableEchoCancellation: value);
                });
              },
            ),
            
            SwitchListTile(
              title: const Text('Supressão de Ruído'),
              subtitle: const Text('Reduz ruídos de fundo'),
              value: _settings!.enableNoiseSuppression,
              onChanged: (value) {
                setState(() {
                  _settings = _settings!.copyWith(enableNoiseSuppression: value);
                });
              },
            ),
            
            SwitchListTile(
              title: const Text('Controle Automático de Ganho'),
              subtitle: const Text('Ajusta automaticamente o volume do microfone'),
              value: _settings!.enableAutoGainControl,
              onChanged: (value) {
                setState(() {
                  _settings = _settings!.copyWith(enableAutoGainControl: value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Servidores STUN/TURN',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // STUN Servers
            const Text('Servidores STUN'),
            const SizedBox(height: 8),
            ..._buildServerList(_stunControllers, 'STUN'),
            
            const SizedBox(height: 16),
            
            // TURN Servers
            const Text('Servidores TURN'),
            const SizedBox(height: 8),
            ..._buildServerList(_turnControllers, 'TURN'),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildServerList(List<TextEditingController> controllers, String type) {
    return [
      ...controllers.asMap().entries.map((entry) {
        int index = entry.key;
        TextEditingController controller = entry.value;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: type == 'STUN' 
                        ? 'stun:stun.example.com:3478'
                        : 'turn:turn.example.com:3478',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () {
                  setState(() {
                    controller.dispose();
                    controllers.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      }),
      ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: Text('Adicionar $type'),
        onPressed: () {
          setState(() {
            controllers.add(TextEditingController());
          });
        },
      ),
    ];
  }

  Widget _buildResetSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Restaurar Padrões',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Restaura todas as configurações para os valores padrão.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.restore),
              label: const Text('Restaurar Configurações Padrão'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _showResetDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Configurações'),
        content: const Text(
          'Tem certeza que deseja restaurar todas as configurações para os valores padrão? '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _settingsService.resetToDefaults();
              await _loadSettings();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configurações restauradas para o padrão!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Restaurar', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}