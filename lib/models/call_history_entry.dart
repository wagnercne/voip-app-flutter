class CallHistoryEntry {
  final String id;
  final String number;
  final DateTime timestamp;
  final Duration duration;
  final CallDirection direction;
  final CallStatus status;
  final bool isVideoCall;

  CallHistoryEntry({
    required this.id,
    required this.number,
    required this.timestamp,
    required this.duration,
    required this.direction,
    required this.status,
    this.isVideoCall = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'duration': duration.inSeconds,
      'direction': direction.name,
      'status': status.name,
      'isVideoCall': isVideoCall,
    };
  }

  factory CallHistoryEntry.fromJson(Map<String, dynamic> json) {
    return CallHistoryEntry(
      id: json['id'],
      number: json['number'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      duration: Duration(seconds: json['duration']),
      direction: CallDirection.values.firstWhere((e) => e.name == json['direction']),
      status: CallStatus.values.firstWhere((e) => e.name == json['status']),
      isVideoCall: json['isVideoCall'] ?? false,
    );
  }
}

enum CallDirection {
  incoming,
  outgoing,
}

enum CallStatus {
  completed,
  missed,
  failed,
  rejected,
}