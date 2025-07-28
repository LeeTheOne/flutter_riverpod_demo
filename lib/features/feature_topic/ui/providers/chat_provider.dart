// lib/features/feature_topic/ui/providers/chat_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/usecases/chat_history_usecase.dart';
import 'providers_setup.dart';

final chatProvider = StateNotifierProvider.family<ChatNotifier, List<ChatMessage>, String>(
  (ref, topicId) {
    final historyUseCase = ref.watch(chatHistoryUseCaseProvider);
    return ChatNotifier(topicId: topicId, historyUseCase: historyUseCase);
  },
);

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final String topicId;
  final ChatHistoryUseCase _historyUseCase;

  ChatNotifier({
    required this.topicId,
    required ChatHistoryUseCase historyUseCase,
  })  : _historyUseCase = historyUseCase,
        super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await _historyUseCase.execute(topicId);
    state = list;
  }

  void sendUserMessage(String text) {
    final msg = ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: text,
      time: DateTime.now(),
      sender: Sender.user,
    );
    state = [...state, msg];
    _sendBotReply(text);
  }

  Future<void> _sendBotReply(String userText) async {
    await Future.delayed(const Duration(seconds: 1));
    final reply = ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: '[翻译] $userText',
      time: DateTime.now(),
      sender: Sender.bot,
    );
    state = [...state, reply];
  }
}
