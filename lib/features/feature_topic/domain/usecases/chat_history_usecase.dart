import '../models/chat_message.dart';
import '../../repo/chat_repository.dart';

/// 用例：获取指定 topicId 的聊天历史
class ChatHistoryUseCase {
  final ChatRepository _repository;
  ChatHistoryUseCase(this._repository);

  Future<List<ChatMessage>> execute(String topicId) {
    return _repository.fetchMessages(topicId);
  }
}