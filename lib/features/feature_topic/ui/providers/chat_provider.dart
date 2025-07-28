import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/usecases/chat_history_usecase.dart';
import '../../repo/chat_repository.dart';
import 'providers_setup.dart';


/// Topic 对应的消息列表 Provider
final chatProvider = StateNotifierProvider
    .family<ChatNotifier, List<ChatMessage>, String>(
  (ref, topicId) {
    final historyUseCase = ref.watch(chatHistoryUseCaseProvider);
    final repository = ref.watch(chatRepositoryProvider);
    return ChatNotifier(
      topicId: topicId,
      historyUseCase: historyUseCase,
      repository: repository,
    );
  },
);

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final String topicId;
  final ChatHistoryUseCase _historyUseCase;
  final ChatRepository _repository;
  late final StreamSubscription<List<ChatMessage>> _sub;

  ChatNotifier({
    required this.topicId,
    required ChatHistoryUseCase historyUseCase,
    required ChatRepository repository,
  })  : _historyUseCase = historyUseCase,
        _repository = repository,
        super([]) {
    // 先加载历史消息并写入本地，触发流更新
    _loadHistory();
    // 再订阅本地消息流
    _sub = _repository.watchMessages(topicId).listen((messages) {
      state = messages;
    });
  }

  /// 加载历史消息（如从服务器），并缓存到本地
  Future<void> _loadHistory() async {
    final history = await _historyUseCase.execute(topicId);
    for (final msg in history) {
      await _repository.saveMessage(topicId, msg);
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
    await _repository.saveMessage(topicId, msg);
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
    await _repository.saveMessage(topicId, reply);
  }
}