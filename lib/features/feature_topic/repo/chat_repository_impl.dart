import '../data_source/chat_local_data_source.dart';
import '../data_source/chat_remote_data_source.dart';
import '../domain/models/chat_message.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remote;
  final ChatLocalDataSource _local;

  ChatRepositoryImpl(this._remote, this._local);

  @override
  Future<List<ChatMessage>> fetchMessages(String topicId) async {
    // 优先从本地缓存
    final cached = await _local.getCachedMessages(topicId);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    // 缓存不存在则从远端获取
    final remote = await _remote.fetchMessagesForTopic(topicId);
    await _local.cacheMessages(topicId, remote);
    return remote;
  }
}