import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/call_history_entry.dart';
import '../services/call_history_service.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CallHistoryService _historyService = CallHistoryService();
  List<CallHistoryEntry> _allCalls = [];
  List<CallHistoryEntry> _missedCalls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allCalls = await _historyService.getCallHistory();
      final missedCalls = await _historyService.getMissedCalls();

      setState(() {
        _allCalls = allCalls;
        _missedCalls = missedCalls;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Chamadas'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _showClearHistoryDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.call),
              text: 'Todas (${_allCalls.length})',
            ),
            Tab(
              icon: const Icon(Icons.call_missed),
              text: 'Perdidas (${_missedCalls.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCallList(_allCalls),
                _buildCallList(_missedCalls),
              ],
            ),
    );
  }

  Widget _buildCallList(List<CallHistoryEntry> calls) {
    if (calls.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.call_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma chamada encontrada',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        itemCount: calls.length,
        itemBuilder: (context, index) {
          final call = calls[index];
          return _buildCallListItem(call);
        },
      ),
    );
  }

  Widget _buildCallListItem(CallHistoryEntry call) {
    final dateFormat = DateFormat('dd/MM HH:mm');
    final isToday = _isToday(call.timestamp);
    final isYesterday = _isYesterday(call.timestamp);
    
    String timeText;
    if (isToday) {
      timeText = DateFormat('HH:mm').format(call.timestamp);
    } else if (isYesterday) {
      timeText = 'Ontem ${DateFormat('HH:mm').format(call.timestamp)}';
    } else {
      timeText = dateFormat.format(call.timestamp);
    }

    IconData callIcon;
    Color iconColor;
    
    switch (call.direction) {
      case CallDirection.incoming:
        switch (call.status) {
          case CallStatus.completed:
            callIcon = Icons.call_received;
            iconColor = Colors.green;
            break;
          case CallStatus.missed:
            callIcon = Icons.call_missed;
            iconColor = Colors.red;
            break;
          case CallStatus.rejected:
            callIcon = Icons.call_missed_outgoing;
            iconColor = Colors.orange;
            break;
          default:
            callIcon = Icons.call_received;
            iconColor = Colors.grey;
        }
        break;
      case CallDirection.outgoing:
        switch (call.status) {
          case CallStatus.completed:
            callIcon = Icons.call_made;
            iconColor = Colors.blue;
            break;
          case CallStatus.failed:
            callIcon = Icons.call_made;
            iconColor = Colors.red;
            break;
          default:
            callIcon = Icons.call_made;
            iconColor = Colors.grey;
        }
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withOpacity(0.1),
          ),
          child: Icon(
            callIcon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                call.number,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (call.isVideoCall)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videocam,
                      size: 12,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Vídeo',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeText,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            if (call.duration.inSeconds > 0)
              Text(
                _formatDuration(call.duration),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (value) {
            switch (value) {
              case 'call':
                // TODO: Implementar nova chamada
                break;
              case 'details':
                _showCallDetails(call);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'call',
              child: Row(
                children: [
                  Icon(Icons.call, size: 16),
                  SizedBox(width: 8),
                  Text('Ligar novamente'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'details',
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16),
                  SizedBox(width: 8),
                  Text('Detalhes'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Implementar ação de toque (ligar novamente)
        },
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
           date.month == yesterday.month &&
           date.day == yesterday.day;
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  void _showCallDetails(CallHistoryEntry call) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalhes da Chamada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Número:', call.number),
            _buildDetailRow('Data:', DateFormat('dd/MM/yyyy').format(call.timestamp)),
            _buildDetailRow('Hora:', DateFormat('HH:mm:ss').format(call.timestamp)),
            _buildDetailRow('Direção:', call.direction == CallDirection.incoming ? 'Recebida' : 'Feita'),
            _buildDetailRow('Status:', _getStatusText(call.status)),
            _buildDetailRow('Duração:', _formatDuration(call.duration)),
            _buildDetailRow('Tipo:', call.isVideoCall ? 'Vídeo chamada' : 'Chamada de voz'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getStatusText(CallStatus status) {
    switch (status) {
      case CallStatus.completed:
        return 'Completada';
      case CallStatus.missed:
        return 'Perdida';
      case CallStatus.failed:
        return 'Falhou';
      case CallStatus.rejected:
        return 'Rejeitada';
    }
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Histórico'),
        content: const Text(
          'Tem certeza que deseja limpar todo o histórico de chamadas? '
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
              await _historyService.clearHistory();
              await _loadHistory();
            },
            child: const Text('Limpar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}