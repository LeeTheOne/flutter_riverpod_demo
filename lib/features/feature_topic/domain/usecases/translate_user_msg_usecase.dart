import '../models/chat_message.dart';
import '../../repo/chat_repository.dart';

class TranslateUserMsgUsecase {
  final ChatRepository _repository;
  TranslateUserMsgUsecase(this._repository);

  Future<ChatMessage> execute(String topicId, ChatMessage userMessage) async {
    // 模拟翻译功能，实际项目中这里会调用真实的翻译API
    final translatedText = '[翻译] ${userMessage.text}';
    
    return ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: translatedText,
      time: DateTime.now(),
      sender: Sender.bot,
    );
  }
}
