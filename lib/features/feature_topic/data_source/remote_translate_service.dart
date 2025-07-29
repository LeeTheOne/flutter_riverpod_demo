

class RemoteTranslateService {
  Future<String> translate(String text) async {
    // 模拟远程翻译API的延迟
    await Future.delayed(const Duration(milliseconds: 800));
    return '【远程翻译】$text';
  }
}
