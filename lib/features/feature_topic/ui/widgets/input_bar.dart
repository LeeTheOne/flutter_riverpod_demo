import 'package:flutter/material.dart';

class InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const InputBar({required this.controller, required this.onSend, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.mic), onPressed: () {/* TODO 语音 */}),
          IconButton(icon: const Icon(Icons.show_chart), onPressed: () {/* TODO 波形 */}),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '输入任何内容',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.language), onPressed: () {/* TODO 切换中/英 */}),
          IconButton(icon: const Icon(Icons.add), onPressed: () {/* TODO 附件 */}),
          IconButton(icon: const Icon(Icons.send), onPressed: onSend),
        ],
      ),
    );
  }
}
