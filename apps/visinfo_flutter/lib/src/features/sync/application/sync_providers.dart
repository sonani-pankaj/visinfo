import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/observability/observability_providers.dart';
import '../infrastructure/in_memory_sync_store.dart';
import '../infrastructure/noop_sync_executor.dart';
import 'sync_queue_service.dart';

final syncQueueStoreProvider = Provider<SyncQueueStore>((Ref ref) {
  return InMemorySyncStore();
});

final syncJobExecutorProvider = Provider<SyncJobExecutor>((Ref ref) {
  return NoopSyncExecutor();
});

final syncQueueServiceProvider = Provider<SyncQueueService>((Ref ref) {
  return SyncQueueService(
    store: ref.watch(syncQueueStoreProvider),
    executor: ref.watch(syncJobExecutorProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
