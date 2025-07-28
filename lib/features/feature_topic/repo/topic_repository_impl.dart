import '../domain/models/topic.dart';
import '../data_source/topic_remote_data_source.dart';
import '../data_source/topic_local_data_source.dart';
import 'topic_repository.dart';

class TopicRepositoryImpl implements TopicRepository {
  final TopicRemoteDataSource _remote;
  final TopicLocalDataSource _local;

  TopicRepositoryImpl(this._remote, this._local);

  @override
  Future<List<Topic>> fetchTopics() async {
    // 优先从缓存读取
    final cached = await _local.getCachedTopics();
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    // 缓存不存在时调用远端，并缓存结果
    final list = await _remote.fetchTopics();
    await _local.cacheTopics(list);
    return list;
  }
}