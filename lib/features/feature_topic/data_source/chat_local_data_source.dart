import '../domain/models/chat_message.dart';

/// 本地缓存模拟
class ChatLocalDataSource {
  final Map<String, List<ChatMessage>> _cache = {};

  Future<List<ChatMessage>?> getCachedMessages(String topicId) async {
    return _cache[topicId];
  }

  Future<void> cacheMessages(String topicId, List<ChatMessage> messages) async {
    _cache[topicId] = messages;
  }
}