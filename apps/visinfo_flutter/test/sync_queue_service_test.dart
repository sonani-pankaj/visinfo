import 'package:flutter_test/flutter_test.dart';
import 'package:visinfo_flutter/src/core/observability/app_logger.dart';
import 'package:visinfo_flutter/src/features/sync/application/sync_queue_service.dart';
import 'package:visinfo_flutter/src/features/sync/domain/sync_job.dart';
import 'package:visinfo_flutter/src/features/sync/infrastructure/in_memory_sync_store.dart';
import 'package:visinfo_flutter/src/features/sync/infrastructure/noop_sync_executor.dart';

void main() {
  test('marks successful job as completed', () async {
    final store = InMemorySyncStore(<SyncJob>[
      const SyncJob(
        id: 'job1',
        type: SyncJobType.uploadPhoto,
        status: SyncJobStatus.queued,
        payload: <String, Object?>{},
      ),
    ]);

    final service = SyncQueueService(
      store: store,
      executor: NoopSyncExecutor(),
      logger: DebugAppLogger(),
    );

    await service.processOnce();

    final jobs = store.snapshotJobs();
    expect(jobs.single.status, SyncJobStatus.completed);
  });

  test('marks failed job with retries incremented', () async {
    final store = InMemorySyncStore(<SyncJob>[
      const SyncJob(
        id: 'job1',
        type: SyncJobType.uploadPhoto,
        status: SyncJobStatus.queued,
        payload: <String, Object?>{'shouldFail': true},
      ),
    ]);

    final service = SyncQueueService(
      store: store,
      executor: NoopSyncExecutor(),
      logger: DebugAppLogger(),
    );

    await service.processOnce();

    final jobs = store.snapshotJobs();
    expect(jobs.single.status, SyncJobStatus.failed);
    expect(jobs.single.retryCount, 1);
  });
}
