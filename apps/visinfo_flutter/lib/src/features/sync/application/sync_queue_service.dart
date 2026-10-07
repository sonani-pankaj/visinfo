import '../../../core/observability/app_logger.dart';
import '../domain/sync_job.dart';

abstract class SyncQueueStore {
  Future<List<SyncJob>> dequeueBatch({int max = 10});
  Future<void> markRunning(String jobId);
  Future<void> markCompleted(String jobId);
  Future<void> markFailed(String jobId, String message);
}

abstract class SyncJobExecutor {
  Future<void> execute(SyncJob job);
}

class SyncQueueService {
  SyncQueueService({
    required SyncQueueStore store,
    required SyncJobExecutor executor,
    required AppLogger logger,
    this.maxRetries = 3,
  })  : _store = store,
        _executor = executor,
        _logger = logger;

  final SyncQueueStore _store;
  final SyncJobExecutor _executor;
  final AppLogger _logger;
  final int maxRetries;

  Future<void> processOnce() async {
    final jobs = await _store.dequeueBatch();
    for (final job in jobs) {
      _logger.info(
        'Processing sync job',
        context: <String, Object?>{'jobId': job.id, 'jobType': job.type.name},
      );
      await _store.markRunning(job.id);
      try {
        await _executor.execute(job);
        await _store.markCompleted(job.id);
        _logger.info(
          'Completed sync job',
          context: <String, Object?>{'jobId': job.id},
        );
      } catch (e) {
        final retriesExhausted = job.retryCount + 1 >= maxRetries;
        final message = retriesExhausted
            ? 'Retries exhausted: ${e.toString()}'
            : 'Retry scheduled: ${e.toString()}';
        await _store.markFailed(job.id, message);
        _logger.warning(
          'Sync job failed',
          context: <String, Object?>{
            'jobId': job.id,
            'retryCount': job.retryCount + 1,
            'retriesExhausted': retriesExhausted,
          },
        );
      }
    }
  }
}
