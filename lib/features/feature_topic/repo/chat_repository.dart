import '../domain/models/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> fetchMessages(String topicId);
  Stream<List<ChatMessage>> watchMessages(String topicId);
  Future<void> saveMessage(String topicId, ChatMessage message);
}