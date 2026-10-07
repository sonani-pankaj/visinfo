import '../application/sync_queue_service.dart';
import '../domain/sync_job.dart';

class NoopSyncExecutor implements SyncJobExecutor {
  @override
  Future<void> execute(SyncJob job) async {
    if (job.payload['shouldFail'] == true) {
      throw StateError('Forced sync failure for testing retries');
    }
  }
}
