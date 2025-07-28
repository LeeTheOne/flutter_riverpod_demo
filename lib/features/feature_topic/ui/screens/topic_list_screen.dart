import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers_setup.dart';
import '../providers/topic_provider.dart';
import '../widgets/topic_tile.dart';
import 'package:go_router/go_router.dart';

class TopicListScreen extends ConsumerWidget {
  const TopicListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsAsync = ref.watch(topicListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('主题')),
      body: topicsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (topics) => ListView.builder(
          itemCount: topics.length,
          itemBuilder: (ctx, i) {
            final t = topics[i];
            return TopicTile(
              topic: t,
              onTap: () {
                ref.read(currentTopicProvider.notifier).state = t;
                context.go('/topics/${t.id}');
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/topics/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}