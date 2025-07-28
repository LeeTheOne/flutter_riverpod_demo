import '../domain/models/topic.dart';

/// 远端数据源：模拟 API 调用
class TopicRemoteDataSource {
  Future<List<Topic>> fetchTopics() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.generate(6, (i) {
      return Topic(
        id: '$i',
        title: '主题 $i',
        subtitle: 'Subtitle for topic $i',
        updatedAt: DateTime.now().subtract(Duration(minutes: i * 5)),
      );
    });
  }
}