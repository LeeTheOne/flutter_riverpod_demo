// lib/features/feature_topic/ui/screens/topic_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/chat_provider.dart';        // chatProvider + currentTopicProvider
import '../providers/providers_setup.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '../../domain/models/topic.dart';

class TopicDetailScreen extends ConsumerStatefulWidget {
  final String topicId;
  const TopicDetailScreen({required this.topicId, Key? key}) : super(key: key);

  @override
  ConsumerState<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends ConsumerState<TopicDetailScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1️⃣ 从全局 Provider 拿当前 Topic（列表页已写入）
    final Topic? topic = ref.watch(currentTopicProvider);

    // 如果没有缓存，说明用户可能直接打开链接，此时可重定向回列表或显示 loading
    if (topic == null || topic.id != widget.topicId) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2️⃣ 拿该 topicId 的消息列表
    final messages = ref.watch(chatProvider(widget.topicId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 返回时清空缓存，避免下次复用错题目
            ref.read(currentTopicProvider.notifier).state = null;
            context.pop();
          },
        ),
        // 3️⃣ 用缓存的 topic.title
        title: Text(topic.title),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('新主题'),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, i) => MessageBubble(messages[i]),
            ),
          ),
          const Divider(height: 1),
          InputBar(
            controller: _controller,
            onSend: () {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              ref
                .read(chatProvider(widget.topicId).notifier)
                .sendUserMessage(text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
