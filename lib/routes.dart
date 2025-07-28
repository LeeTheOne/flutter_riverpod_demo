import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/feature_topic/ui/screens/topic_list_screen.dart';
import 'features/feature_topic/ui/screens/topic_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/topics',
  routes: [
    GoRoute(
      path: '/topics',
      builder: (ctx, state) => const TopicListScreen(),
      routes: [
        GoRoute(
          path: ':topicId',
          builder: (ctx, state) {
            final id = state.pathParameters['topicId']!;
            return TopicDetailScreen(topicId: id);
          },
        ),
      ],
    ),
  ],
));