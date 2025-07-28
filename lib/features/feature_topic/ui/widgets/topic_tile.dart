import 'package:flutter/material.dart';
import '../../domain/models/topic.dart';
import 'package:intl/intl.dart';

class TopicTile extends StatelessWidget {
  final Topic topic;
  final VoidCallback onTap;

  const TopicTile({required this.topic, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('MM-dd HH:mm').format(topic.updatedAt);
    return ListTile(
      leading: const Icon(Icons.folder, color: Colors.deepPurple),
      title: Text(topic.title),
      subtitle: Text(topic.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(time),
      onTap: onTap,
    );
  }
}
