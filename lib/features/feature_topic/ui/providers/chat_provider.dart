// lib/features/feature_topic/ui/providers/chat_provider.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/chat_message.dart';
import 'providers_setup.dart'; // 导出 chatHistoryUseCaseProvider & chatRepositoryProvider

/// 按 topicId 区分不同会话的 Provider
final chatProvider = StateNotifierProvider.family<
    ChatNotifier,
    List<ChatMessage>,
    String>((ref, topicId) {
  // 只传入 ref 和 topicId
  return ChatNotifier(ref, topicId);
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;
  final String topicId;
  late final StreamSubscription<List<ChatMessage>> _sub;

  ChatNotifier(this._ref, this.topicId) : super([]) {
    // 拉历史并缓存到本地
    _loadHistory();
    // 订阅本地消息流，自动更新 UI
    _sub = _ref
        .read(chatRepositoryProvider)
        .watchMessages(topicId)
        .listen((messages) {
      state = messages;
    });
  }

  Future<void> _loadHistory() async {
    // 随用随取历史用例
    final history =
        await _ref.read(chatHistoryUseCaseProvider).execute(topicId);
    // 缓存到本地，触发 watchMessages 流更新
    final repo = _ref.read(chatRepositoryProvider);
    for (final msg in history) {
      await repo.saveMessage(topicId, msg);
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  /// 发送用户消息
  Future<void> sendUserMessage(String text) async {
    final msg = ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: text,
      time: DateTime.now(),
      sender: Sender.user,
    );
   // 先更新 UI
    state = [...state, msg];

    // 随用随取，用例也从 Ref 拿
    final sendUseCase = _ref.read(sendUserMessageUsecaseProvider);
    sendUseCase.execute(topicId, msg);

    // 模拟 Bot 回复
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
    await _ref.read(chatRepositoryProvider).saveMessage(topicId, reply);
  }
}
