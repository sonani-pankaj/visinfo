import '../application/sync_queue_service.dart';
import '../domain/sync_job.dart';

class InMemorySyncStore implements SyncQueueStore {
  final List<SyncJob> _jobs;

  InMemorySyncStore([List<SyncJob>? seedJobs]) : _jobs = seedJobs ?? <SyncJob>[];

  List<SyncJob> snapshotJobs() => List<SyncJob>.unmodifiable(_jobs);

  @override
  Future<List<SyncJob>> dequeueBatch({int max = 10}) async {
    return _jobs.where((SyncJob j) => j.status == SyncJobStatus.queued).take(max).toList(growable: false);
  }

  @override
  Future<void> markCompleted(String jobId) async {
    _replaceJob(jobId, (SyncJob job) => SyncJob(
          id: job.id,
          type: job.type,
          status: SyncJobStatus.completed,
          payload: job.payload,
          retryCount: job.retryCount,
          lastError: job.lastError,
        ));
  }

  @override
  Future<void> markFailed(String jobId, String message) async {
    _replaceJob(jobId, (SyncJob job) => SyncJob(
          id: job.id,
          type: job.type,
          status: SyncJobStatus.failed,
          payload: job.payload,
          retryCount: job.retryCount + 1,
          lastError: message,
        ));
  }

  @override
  Future<void> markRunning(String jobId) async {
    _replaceJob(jobId, (SyncJob job) => SyncJob(
          id: job.id,
          type: job.type,
          status: SyncJobStatus.running,
          payload: job.payload,
          retryCount: job.retryCount,
          lastError: job.lastError,
        ));
  }

  void _replaceJob(String jobId, SyncJob Function(SyncJob old) mutate) {
    final index = _jobs.indexWhere((SyncJob j) => j.id == jobId);
    if (index < 0) {
      throw StateError('Sync job not found: $jobId');
    }
    _jobs[index] = mutate(_jobs[index]);
  }
}
