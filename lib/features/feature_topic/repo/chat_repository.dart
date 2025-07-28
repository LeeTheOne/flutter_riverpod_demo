import '../domain/models/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> fetchMessages(String topicId);
}