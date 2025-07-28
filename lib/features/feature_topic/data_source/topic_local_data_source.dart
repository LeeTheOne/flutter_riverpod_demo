import '../domain/models/topic.dart';

/// 本地缓存数据源
class TopicLocalDataSource {
  final Map<String, List<Topic>> _cache = {};

  Future<void> cacheTopics(List<Topic> topics) async {
    _cache['all'] = topics;
  }

  Future<List<Topic>?> getCachedTopics() async {
    return _cache['all'];
  }
}