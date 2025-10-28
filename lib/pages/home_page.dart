import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sip_service.dart';
import '../services/permission_service.dart';
import 'call_screen.dart';
import 'call_history_screen.dart';
import 'settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _serverCtrl = TextEditingController(text: 'wss://sip.example.com');
  final TextEditingController _userCtrl = TextEditingController(text: '1001');
  final TextEditingController _passCtrl = TextEditingController(text: 'password');
  final TextEditingController _targetCtrl = TextEditingController(text: '1002');
  bool _isVideoCall = false;

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissão Necessária'),
          content: const Text(
            'Este app precisa de acesso ao microfone para realizar chamadas de voz. '
            'Por favor, conceda a permissão nas configurações do dispositivo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await PermissionService.openAppSettings();
              },
              child: const Text('Abrir Configurações'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sip = Provider.of<SipService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VOIP Flutter — Demo'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CallHistoryScreen(),
                ),
              );
            },
            tooltip: 'Histórico de chamadas',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    TextField(controller: _serverCtrl, decoration: const InputDecoration(labelText: 'SIP WebSocket (wss://)')),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Usuário'))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true)),
                    ]),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('Registrar / Atualizar'),
                      onPressed: () => sip.register(_serverCtrl.text.trim(), _userCtrl.text.trim(), _passCtrl.text.trim()),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<String>(
                      stream: sip.registrationState,
                      initialData: 'Não registrado',
                      builder: (context, snap) {
                        return Text('Status: ${snap.data}', style: const TextStyle(fontWeight: FontWeight.w600));
                      },
                    ),
                  ]),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    TextField(controller: _targetCtrl, decoration: const InputDecoration(labelText: 'Destino (ex: 1002)')),
                    const SizedBox(height: 12),
                    
                    // Toggle de vídeo
                    Row(
                      children: [
                        Switch(
                          value: _isVideoCall,
                          onChanged: (value) {
                            setState(() {
                              _isVideoCall = value;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Chamada de vídeo',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Row(children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.call),
                          label: const Text('Ligar'),
                          onPressed: () async {
                            final target = _targetCtrl.text.trim();
                            if (target.isNotEmpty) {
                              // Solicitar permissões antes de fazer a chamada
                              final permissions = await PermissionService.requestCallPermissions(needCamera: _isVideoCall);
                              
                              bool canMakeCall = permissions['microphone'] == true;
                              if (_isVideoCall) {
                                canMakeCall = canMakeCall && permissions['camera'] == true;
                              }
                              
                              if (canMakeCall) {
                                sip.call(target, voiceOnly: !_isVideoCall);
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CallScreen(
                                        targetNumber: target,
                                        isVideoCall: _isVideoCall,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                if (mounted) {
                                  _showPermissionDialog();
                                }
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.call_end),
                          label: const Text('Desligar'),
                          onPressed: () => sip.hangup(),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    StreamBuilder<String>(
                      stream: sip.callState,
                      initialData: 'Ocioso',
                      builder: (context, snap) => Text('Chamada: ${snap.data}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),
              ),

              const SizedBox(height: 24),

              Center(child: Text('Design simples e moderno — personalize cores, tipografia e animações conforme desejado', style: Theme.of(context).textTheme.bodySmall)),
            ],
          ),
        ),
      ),
    );
  }
}
