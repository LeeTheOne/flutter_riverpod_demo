import '../models/chat_message.dart';
import '../../repo/chat_repository.dart';

class SendUserMessageUsecase {

  final ChatRepository _repository;
  SendUserMessageUsecase(this._repository);

  Future<void> execute(String topicId, ChatMessage message) {
    return _repository.saveMessage(topicId, message);
  }
}