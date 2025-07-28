import 'dart:async';
import '../domain/models/chat_message.dart';

/// 本地缓存模拟 + 消息列表变化流
class ChatLocalDataSource {
  /// 缓存：topicId -> 消息列表
  final Map<String, List<ChatMessage>> _cache = {};
  
  /// 每个 topic 对应一个 StreamController，用于推送消息列表变化
  final Map<String, StreamController<List<ChatMessage>>> _controllers = {};

  /// 获取指定 topic 的消息列表变化流
  Stream<List<ChatMessage>> watchMessages(String topicId) {
    return _getController(topicId).stream;
  }

  /// 获取当前缓存的消息列表
  Future<List<ChatMessage>?> getCachedMessages(String topicId) async {
    return _cache[topicId];
  }

  /// 缓存消息列表并通知变化
  Future<void> cacheMessages(String topicId, List<ChatMessage> messages) async {
    // 更新缓存
    _cache[topicId] = List.unmodifiable(messages);
    // 推送最新列表
    _getController(topicId).add(List.unmodifiable(messages));
  }

  /// 获取或创建对应 topic 的 StreamController
  StreamController<List<ChatMessage>> _getController(String topicId) {
    if (!_controllers.containsKey(topicId)) {
      // broadcast 模式允许多个订阅者
      final controller = StreamController<List<ChatMessage>>.broadcast();
      _controllers[topicId] = controller;
      // 如果已有缓存，则先推送一次初始值
      final initial = _cache[topicId];
      if (initial != null) {
        controller.add(List.unmodifiable(initial));
      }
    }
    return _controllers[topicId]!;
  }

  /// 关闭所有 StreamController，释放资源
  Future<void> dispose() async {
    for (final controller in _controllers.values) {
      await controller.close();
    }
    _controllers.clear();
  }
}
