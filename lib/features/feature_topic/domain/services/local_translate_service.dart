import '../models/chat_message.dart';

class LocalTranslateService {
  Future<String> translate(String text) async {
    // 模拟本地翻译API的延迟
    await Future.delayed(const Duration(milliseconds: 300));
    return '【本地翻译】$text';
  }
}
