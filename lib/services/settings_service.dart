import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final String audioCodec;
  final String videoCodec;
  final List<String> stunServers;
  final List<String> turnServers;
  final int audioQuality; // 0-100
  final int videoQuality; // 0-100
  final bool enableEchoCancellation;
  final bool enableNoiseSuppression;
  final bool enableAutoGainControl;

  AppSettings({
    this.audioCodec = 'OPUS',
    this.videoCodec = 'VP8',
    this.stunServers = const ['stun:stun.l.google.com:19302'],
    this.turnServers = const [],
    this.audioQuality = 80,
    this.videoQuality = 70,
    this.enableEchoCancellation = true,
    this.enableNoiseSuppression = true,
    this.enableAutoGainControl = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'audioCodec': audioCodec,
      'videoCodec': videoCodec,
      'stunServers': stunServers,
      'turnServers': turnServers,
      'audioQuality': audioQuality,
      'videoQuality': videoQuality,
      'enableEchoCancellation': enableEchoCancellation,
      'enableNoiseSuppression': enableNoiseSuppression,
      'enableAutoGainControl': enableAutoGainControl,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      audioCodec: json['audioCodec'] ?? 'OPUS',
      videoCodec: json['videoCodec'] ?? 'VP8',
      stunServers: List<String>.from(json['stunServers'] ?? ['stun:stun.l.google.com:19302']),
      turnServers: List<String>.from(json['turnServers'] ?? []),
      audioQuality: json['audioQuality'] ?? 80,
      videoQuality: json['videoQuality'] ?? 70,
      enableEchoCancellation: json['enableEchoCancellation'] ?? true,
      enableNoiseSuppression: json['enableNoiseSuppression'] ?? true,
      enableAutoGainControl: json['enableAutoGainControl'] ?? true,
    );
  }

  AppSettings copyWith({
    String? audioCodec,
    String? videoCodec,
    List<String>? stunServers,
    List<String>? turnServers,
    int? audioQuality,
    int? videoQuality,
    bool? enableEchoCancellation,
    bool? enableNoiseSuppression,
    bool? enableAutoGainControl,
  }) {
    return AppSettings(
      audioCodec: audioCodec ?? this.audioCodec,
      videoCodec: videoCodec ?? this.videoCodec,
      stunServers: stunServers ?? this.stunServers,
      turnServers: turnServers ?? this.turnServers,
      audioQuality: audioQuality ?? this.audioQuality,
      videoQuality: videoQuality ?? this.videoQuality,
      enableEchoCancellation: enableEchoCancellation ?? this.enableEchoCancellation,
      enableNoiseSuppression: enableNoiseSuppression ?? this.enableNoiseSuppression,
      enableAutoGainControl: enableAutoGainControl ?? this.enableAutoGainControl,
    );
  }
}

class SettingsService {
  static const String _settingsKey = 'app_settings';

  Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson != null) {
      return AppSettings.fromJson(json.decode(settingsJson));
    }
    
    return AppSettings(); // Retorna configurações padrão
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, json.encode(settings.toJson()));
  }

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);
  }
}