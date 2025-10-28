import 'dart:async';
import 'package:flutter/material.dart';

// Observação: estes imports dependem dos pacotes listados no pubspec.yaml
// e podem exigir configuração nativa adicional (Android/iOS) para microfone e áudio.
import 'package:sip_ua/sip_ua.dart';

class SipService with ChangeNotifier implements SipUaHelperListener {
  final _regStateController = StreamController<String>.broadcast();
  final _callStateController = StreamController<String>.broadcast();

  Stream<String> get registrationState => _regStateController.stream;
  Stream<String> get callState => _callStateController.stream;
  
  bool get isMuted => _isMuted;
  bool get isSpeakerOn => _isSpeakerOn;

  SIPUAHelper? _helper;
  Call? _currentCall;
  String? _lastWebsocketUri;
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  SipService() {
    // O setup do SIPUAHelper será feito no método register para permitir parâmetros dinâmicos.
  }

  void register(String websocketUri, String username, String password) async {
    _lastWebsocketUri = websocketUri;
    // Exemplo de configuração básica. Ajuste conforme seu servidor SIP.
    final config = UaSettings();
    config.webSocketUrl = websocketUri;
    config.webSocketSettings.extraHeaders = {};
    config.uri = 'sip:$username@${_extractHost(websocketUri)}';
    config.authorizationUser = username;
    config.password = password;
    config.displayName = username;
    config.userAgent = 'VOIP-Flutter-Demo';
    config.register = true;

    _helper = SIPUAHelper();
    _helper!.addSipUaHelperListener(this);
    _helper!.start(config);
    _regStateController.add('Registrando...');
  }

  Future<void> unregister() async {
    try {
      _helper?.stop();
      _regStateController.add('Desregistrado');
    } catch (e) {
      _regStateController.add('Erro ao desregistrar');
    }
  }

  void call(String target, {bool voiceOnly = true}) async {
    if (_helper == null) {
      _callStateController.add('Cliente SIP não registrado');
      return;
    }
    // Usar host direto ou padrão
    final host = _extractHost(_lastWebsocketUri ?? 'sip.example.com');
    final uri = 'sip:$target@$host';
    try {
      bool success = await _helper!.call(uri, voiceOnly: voiceOnly);
      if (success) {
        _callStateController.add('Disparando chamada para $target');
      } else {
        _callStateController.add('Falha ao iniciar chamada');
      }
    } catch (e) {
      _callStateController.add('Erro ao ligar: $e');
    }
  }

  void hangup() {
    _currentCall?.hangup();
    _callStateController.add('Desligado');
  }

  void toggleMute() {
    if (_currentCall != null) {
      if (_isMuted) {
        _currentCall!.unmute();
        _isMuted = false;
        _callStateController.add('Som ativo');
      } else {
        _currentCall!.mute();
        _isMuted = true;
        _callStateController.add('Mudo');
      }
    }
  }

  void toggleSpeaker() {
    if (_currentCall != null) {
      // Note: flutter_webrtc permite controlar o speaker
      // Aqui é um placeholder - a implementação real depende do WebRTC
      _isSpeakerOn = !_isSpeakerOn;
      _callStateController.add('Speaker ${_isSpeakerOn ? 'ligado' : 'desligado'}');
    }
  }

  void answerCall() {
    if (_currentCall != null) {
      _currentCall!.answer(_helper!.buildCallOptions());
      _callStateController.add('Chamada atendida');
    }
  }

  String _extractHost(String websocketUri) {
    // tentativa simples de extrair host de um `wss://host:port/path` -> host
    try {
      final uri = Uri.parse(websocketUri);
      return uri.host;
    } catch (e) {
      return websocketUri;
    }
  }

  // === Implementação de SipUaHelperListener (callbacks do sip_ua) ===
  @override
  void registrationStateChanged(RegistrationState state) {
    String stateStr;
    switch (state.state) {
      case RegistrationStateEnum.REGISTRATION_FAILED:
        stateStr = 'Falha no registro';
        break;
      case RegistrationStateEnum.REGISTERED:
        stateStr = 'Registrado';
        break;
      case RegistrationStateEnum.UNREGISTERED:
        stateStr = 'Não registrado';
        break;
      default:
        stateStr = 'Registrando...';
    }
    _regStateController.add(stateStr);
  }

  @override
  void callStateChanged(Call call, CallState state) {
    _currentCall = call; // Salvar referência da chamada atual
    String stateStr;
    switch (state.state) {
      case CallStateEnum.CALL_INITIATION:
        stateStr = 'Iniciando chamada';
        break;
      case CallStateEnum.CONNECTING:
        stateStr = 'Conectando';
        break;
      case CallStateEnum.CONFIRMED:
        stateStr = 'Chamada confirmada';
        break;
      case CallStateEnum.ENDED:
        stateStr = 'Chamada encerrada';
        break;
      case CallStateEnum.FAILED:
        stateStr = 'Chamada falhou';
        break;
      case CallStateEnum.MUTED:
        stateStr = 'Mudo';
        break;
      case CallStateEnum.UNMUTED:
        stateStr = 'Som ativo';
        break;
      default:
        stateStr = 'Estado: ${state.state}';
    }
    _callStateController.add(stateStr);
  }

  @override
  void transportStateChanged(TransportState state) {
    // Implementar como desejar: logs, UI, etc.
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // Implementar como desejar: notificações, UI, etc.
  }

  @override
  void onNewNotify(Notify ntf) {
    // Implementar como desejar: notificações SIP NOTIFY
  }

  @override
  void onNewReinvite(ReInvite event) {
    // Implementar como desejar: re-invites durante chamadas
  }

  @override
  void dispose() {
    _helper?.stop();
    _regStateController.close();
    _callStateController.close();
    super.dispose();
  }
}
