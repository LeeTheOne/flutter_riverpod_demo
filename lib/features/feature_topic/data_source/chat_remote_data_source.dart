import '../domain/models/chat_message.dart';

/// 模拟远端接口，返回消息列表
class ChatRemoteDataSource {
  Future<List<ChatMessage>> fetchMessagesForTopic(String topicId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.generate(10, (i) {
      return ChatMessage(
        id: '$topicId-msg-$i',
        text: '消息 $i 内容',
        time: DateTime.now().subtract(Duration(minutes: i * 3)),
        sender: i.isEven ? Sender.user : Sender.bot,
      );
    });
  }
}