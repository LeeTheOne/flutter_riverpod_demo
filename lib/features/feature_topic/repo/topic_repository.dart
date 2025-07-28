import '../domain/models/topic.dart';

/// 抽象仓库：隐藏数据源细节
abstract class TopicRepository {
  Future<List<Topic>> fetchTopics();
}