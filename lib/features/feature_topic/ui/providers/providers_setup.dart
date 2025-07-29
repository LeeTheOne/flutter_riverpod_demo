import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data_source/chat_local_data_source.dart';
import '../../data_source/chat_remote_data_source.dart';
import '../../data_source/topic_remote_data_source.dart';
import '../../data_source/topic_local_data_source.dart';
import '../../domain/usecases/chat_history_usecase.dart';
import '../../domain/usecases/send_user_message_usecase.dart';
import '../../repo/chat_repository.dart';
import '../../repo/chat_repository_impl.dart';
import '../../repo/topic_repository_impl.dart';
import '../../repo/topic_repository.dart';
import '../../domain/usecases/get_topics_usecase.dart';
import '../../domain/models/topic.dart';

//*****
//
// topic 列表相关
//
// */

/// DataSource Providers
final topicRemoteDataSourceProvider = Provider((_) => TopicRemoteDataSource());
final topicLocalDataSourceProvider = Provider((_) => TopicLocalDataSource());

/// Repository Provider
final topicRepositoryProvider = Provider<TopicRepository>((ref) {
  return TopicRepositoryImpl(
    ref.watch(topicRemoteDataSourceProvider),
    ref.watch(topicLocalDataSourceProvider),
  );
});

/// UseCase Provider
final getTopicsUseCaseProvider = Provider((ref) {
  return GetTopicsUseCase(ref.watch(topicRepositoryProvider));
});


//*********
//
// chat message相关
//
// */
/// DataSource Providers
final chatRemoteDataSourceProvider = Provider((ref) => ChatRemoteDataSource());
final chatLocalDataSourceProvider  = Provider((ref) => ChatLocalDataSource());

/// Repository Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    ref.watch(chatRemoteDataSourceProvider),
    ref.watch(chatLocalDataSourceProvider),
  );
});

/// UseCase Provider
final chatHistoryUseCaseProvider = Provider((ref) {
  return ChatHistoryUseCase(ref.watch(chatRepositoryProvider));
});

///发送消息用例
final sendUserMessageUsecaseProvider = Provider<SendUserMessageUsecase>((ref) {
  return SendUserMessageUsecase(ref.watch(chatRepositoryProvider));
});

//***
//
// 其他配置
//
// */


/// 全局保存「当前正在查看」的 Topic
final currentTopicProvider = StateProvider<Topic?>((ref) => null);