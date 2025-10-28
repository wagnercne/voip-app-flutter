import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/sip_service.dart';

class CallScreen extends StatefulWidget {
  final String targetNumber;
  final bool isIncoming;
  final bool isVideoCall;

  const CallScreen({
    super.key,
    required this.targetNumber,
    this.isIncoming = false,
    this.isVideoCall = false,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  Timer? _callTimer;
  int _callDuration = 0;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isVideoEnabled = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _startCallTimer();
    
    if (widget.isVideoCall) {
      _initVideoRenderers();
    }
  }

  void _initVideoRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _callTimer?.cancel();
    if (widget.isVideoCall) {
      _localRenderer.dispose();
      _remoteRenderer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: widget.isVideoCall ? _buildVideoCallLayout() : _buildVoiceCallLayout(),
      ),
    );
  }

  Widget _buildVoiceCallLayout() {
    final sip = Provider.of<SipService>(context);
    
    return Column(
      children: [
        // Header com info da chamada
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar/Círculo do contato
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 120 + (_pulseController.value * 20),
                      height: 120 + (_pulseController.value * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Número/Nome do contato
                Text(
                  widget.targetNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Status da chamada
                StreamBuilder<String>(
                  stream: sip.callState,
                  builder: (context, snapshot) {
                    final status = snapshot.data ?? 'Conectando...';
                    return Text(
                      status,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Timer da chamada
                if (_callDuration > 0)
                  Text(
                    _formatDuration(_callDuration),
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        // Controles da chamada
        _buildCallControls(sip),
      ],
    );
  }

  Widget _buildVideoCallLayout() {
    final sip = Provider.of<SipService>(context);
    
    return Stack(
      children: [
        // Vídeo remoto (fundo)
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _remoteRenderer.srcObject != null
              ? RTCVideoView(_remoteRenderer)
              : const Center(
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white54,
                  ),
                ),
        ),
        
        // Info da chamada no topo
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Column(
            children: [
              Text(
                widget.targetNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<String>(
                stream: sip.callState,
                builder: (context, snapshot) {
                  final status = snapshot.data ?? 'Conectando...';
                  return Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (_callDuration > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatDuration(_callDuration),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Vídeo local (preview)
        Positioned(
          top: 100,
          right: 20,
          child: Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _localRenderer.srcObject != null
                  ? RTCVideoView(_localRenderer, mirror: true)
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.videocam_off,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
            ),
          ),
        ),
        
        // Controles na parte inferior
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: _buildCallControls(sip, isVideoCall: true),
          ),
        ),
      ],
    );
  }

  Widget _buildCallControls(SipService sip, {bool isVideoCall = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primeira linha de controles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mute
            _buildControlButton(
              icon: sip.isMuted ? Icons.mic_off : Icons.mic,
              isActive: sip.isMuted,
              onPressed: () {
                sip.toggleMute();
              },
            ),
            
            // Speaker (apenas para chamadas de voz)
            if (!isVideoCall)
              _buildControlButton(
                icon: sip.isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                isActive: sip.isSpeakerOn,
                onPressed: () {
                  sip.toggleSpeaker();
                },
              ),
            
            // Toggle vídeo (apenas para chamadas de vídeo)
            if (isVideoCall)
              _buildControlButton(
                icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                isActive: _isVideoEnabled,
                onPressed: () {
                  setState(() {
                    _isVideoEnabled = !_isVideoEnabled;
                  });
                  // TODO: Implementar toggle de vídeo real
                },
              ),
            
            // Adicionar participante (placeholder)
            _buildControlButton(
              icon: Icons.person_add,
              isActive: false,
              onPressed: () {
                // TODO: Implementar
              },
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Botão de desligar
        GestureDetector(
          onTap: () {
            sip.hangup();
            Navigator.of(context).pop();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.teal : Colors.grey[800],
          border: Border.all(
            color: isActive ? Colors.teal : Colors.grey[600]!,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}