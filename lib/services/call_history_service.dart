import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/call_history_entry.dart';

class CallHistoryService {
  static const String _historyKey = 'call_history';
  static const int _maxHistoryEntries = 100;

  Future<List<CallHistoryEntry>> getCallHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    
    return historyJson
        .map((jsonStr) => CallHistoryEntry.fromJson(json.decode(jsonStr)))
        .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Mais recentes primeiro
  }

  Future<void> addCallHistoryEntry(CallHistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getCallHistory();
    
    // Adiciona nova entrada no início
    history.insert(0, entry);
    
    // Limita o número de entradas
    if (history.length > _maxHistoryEntries) {
      history.removeRange(_maxHistoryEntries, history.length);
    }
    
    // Salva de volta
    final historyJson = history
        .map((entry) => json.encode(entry.toJson()))
        .toList();
    
    await prefs.setStringList(_historyKey, historyJson);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<List<CallHistoryEntry>> getRecentCalls({int limit = 10}) async {
    final history = await getCallHistory();
    return history.take(limit).toList();
  }

  Future<List<CallHistoryEntry>> getMissedCalls() async {
    final history = await getCallHistory();
    return history
        .where((entry) => entry.status == CallStatus.missed)
        .toList();
  }
}