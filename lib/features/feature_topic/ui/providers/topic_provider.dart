import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/topic.dart';
import '../../domain/usecases/get_topics_usecase.dart';
import 'providers_setup.dart';

/// StateNotifierProvider 管理主题列表状态
final topicListProvider = StateNotifierProvider<
    TopicListNotifier, AsyncValue<List<Topic>>>(
  (ref) {
    return TopicListNotifier(ref.watch(getTopicsUseCaseProvider));
  },
);

class TopicListNotifier extends StateNotifier<AsyncValue<List<Topic>>> {
  final GetTopicsUseCase _usecase;

  TopicListNotifier(this._usecase) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final list = await _usecase.execute();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
