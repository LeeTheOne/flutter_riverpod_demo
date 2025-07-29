import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../../data_source/local_translate_service.dart';
import '../../data_source/remote_translate_service.dart';
import '../../repo/chat_repository.dart';
import '../../ui/providers/providers_setup.dart';

class TranslateUserMsgUsecase {
  final ChatRepository _repository;
  final LocalTranslateService _localTranslateService;
  final RemoteTranslateService _remoteTranslateService;
  final ProviderContainer _container;
  
  TranslateUserMsgUsecase(
    this._repository, 
    this._localTranslateService, 
    this._remoteTranslateService, 
    this._container,
  );

  Future<ChatMessage> execute(String topicId, ChatMessage userMessage) async {
    // 动态获取当前的API切换状态
    final useRemoteApi = _container.read(useRemoteApiProvider.notifier).state;
    
    // 根据开关选择使用本地API还是远程API
    final translatedText = useRemoteApi 
        ? await _remoteTranslateService.translate(userMessage.text)
        : await _localTranslateService.translate(userMessage.text);
    
    return ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: translatedText,
      time: DateTime.now(),
      sender: Sender.bot,
    );
  }
}
