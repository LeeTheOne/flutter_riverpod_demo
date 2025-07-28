import '../models/topic.dart';
import '../../repo/topic_repository.dart';

/// 领域用例：获取主题列表
class GetTopicsUseCase {
  final TopicRepository _repo;
  GetTopicsUseCase(this._repo);

  Future<List<Topic>> execute() {
    return _repo.fetchTopics();
  }
}